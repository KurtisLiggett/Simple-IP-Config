;==============================================================================
; Filename:		asyncProcess.au3
; Description:	Run commands asynchronously, then process the results.
;               Chain commands to run after the previous command finishes.
; Author:       Kurtis Liggett
;==============================================================================

Global $iPID = -1, $pRuntime
Global $pRunning, $pDone, $sStdOut, $sStdErr, $pIdle=1
Global $pQueue[1][2]=[[0,0]]

;Incoming command: Execute or add the the Queue
Func _asyncNewCmd($sCmd, $sMessage="", $addToQueue=-1)
	If not ProcessExists ( $iPID ) Then
		$sStdOut = ""
		$sStdErr = ""
		_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, False)
		ConsoleWrite($sCmd&@CRLF)
		$showWarning = 0
		;Run command and end with a unique string so we know the command is finished
		$iPID = Run(@ComSpec & " /k " & $sCmd & "& echo simple ip config cmd done", "", @SW_HIDE, $STDIN_CHILD+$STDERR_MERGED)
		$pRuntime = TimerInit()
		$pIdle = 0
		If $sMessage <> "" Then
			_setStatus($sMessage)
		EndIf
		;Sleep(500)
	ElseIf $addToQueue Then
		_asyncAddToQueue($sCmd, $sMessage)
	EndIf
EndFunc

;add a new command to the Queue
Func _asyncAddToQueue($sCmd, $sMessage)
	$pQueue[0][0] = $pQueue[0][0] + 1
	_ArrayAdd($pQueue, $sCmd&"|"&$sMessage)
EndFunc

;check to see if any more items in the Queue
Func _asyncCheckQueue()
	If $pQueue[0][0] > 0 Then
		_asyncNewCmd($pQueue[1][0], $pQueue[1][1])
		_ArrayDelete($pQueue, 1)
		$pQueue[0][0] = $pQueue[0][0] -1
	EndIf
EndFunc

;delete all items in the Queue
Func _asyncClearQueue()
	If $pQueue[0][0] > 0 Then
		_ArrayDelete($pQueue, "1-"&$pQueue[0][0])
		$pQueue[0][0] = 0
	EndIf
EndFunc

;process the async Queue
Func _asyncProcess()
	Local $dTimeout
	$pExists = ProcessExists ( $iPID )
	If $pExists Then
		$sStdOut = $sStdOut & StdoutRead($iPID)
		$sStdErr = $sStdErr & StderrRead ($iPID)

		;ConsoleWrite($sStdOut&@CRLF)
		if StringInStr($sStdOut, "simple ip config cmd done") Then	;look for our unique phrase to signal we're done
			$sStdOut = StringLeft($sStdOut, StringLen($sStdOut)-33)
			ProcessClose($iPID)
			$pDone = 1
			$iPID = -1
		ElseIf TimerDiff($pRuntime) > 10000 Then
			$dTimeout = 1
			$sStdOut = ""
			ProcessClose($iPID)
			$pDone = 1
			$iPID = -1
			ConsoleWrite("Timeout" & @CRLF)
		Else
			$countdown = 10 - Round(TimerDiff($pRuntime)/1000)
			if $countdown <=5 Then
				_setStatus($sStatusMessage & "  " & "Timeout in " & $countdown & " seconds",0,1)
			EndIf
		EndIf
	Else
		$pIdle = 1
	EndIf

	If $pDone Then
		$pDone = 0
		If $dTimeout Then
			$dTimeout = 0
			_setStatus("Action timed out!  Command Aborted.", 1)
			_asyncClearQueue()
			_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
		Else
	 		;ConsoleWrite($sStdOut&@CRLF)
			If StringInStr($sStdOut, "failed") Then
				_setStatus(StringReplace($sStdOut, @CRLF, " "), 1)
				IF $pQueue[0][0] = 0 Then
					_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
				EndIf
			Else
				IF $pQueue[0][0] = 0 Then
					_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
					If not $showWarning Then _setStatus("Ready")
				EndIf
			EndIf
		EndIf
		_updateCurrent()
		_asyncCheckQueue()
	EndIf
EndFunc