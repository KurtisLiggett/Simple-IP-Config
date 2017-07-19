#include-once
;==============================================================================
; Filename:		asyncRun.au3
; Description:	Run commands 'asynchronously', then process the results.
;               Chain commands to run after the previous command finishes.
; Author:       Kurtis Liggett
;==============================================================================

Global $iPID = -1, $pRuntime
Global $pRunning, $pDone, $sStdOut, $sStdErr, $pIdle=1
Global $pQueue[1][2]=[[0,0]]

#include <Array.au3>

Global $__asyncProcess__Data[1][5]
$__asyncProcess__Data[0][0] = -1
$__asyncProcess__Data[0][2] = 1
;[0][0] = PID
;[0][1] = PID runtime
;[0][2] = idle status
;[0][3] = timeout countdown
;
;[1][0] = command 1 command
;[1][1] = command 1 callback function
;[1][2] = command 1 description
;[1][3] = command 1 timeout
; ...
;[n][0] = command n command
;[n][1] = command n callback function
;[n][2] = command n description
;[n][3] = command n timeout

Func asyncRun($sCmd, $CallbackFunc, $sDescription="", $iTimeout=10000)
	_ArrayAdd($__asyncProcess__Data, $sCmd)
	$size = UBound($__asyncProcess__Data)
	$__asyncProcess__Data[$size-1][1] = $CallbackFunc
	$__asyncProcess__Data[$size-1][2] = $sDescription
	$__asyncProcess__Data[$size-1][3] = $iTimeout
	if $size = 2 Then
		ConsoleWrite("callback"&@CRLF)
		$CallbackFunc($sDescription, $sDescription, "")
	EndIf
	AdlibRegister("_asyncRun_Process", 100)
EndFunc

Func _asyncRun_Execute($sCmd)

EndFunc

Func _asyncRun_Process()
	Local $endingString = "__asyncRun cmd done"

	Local $pExists = ProcessExists ( $__asyncProcess__Data[0][0] )
	If $pExists Then	;if process exists, check if finished
		Local $pDone

		$sStdOut = $sStdOut & StdoutRead( $__asyncProcess__Data[0][0] )
		$sStdErr = $sStdErr & StderrRead ( $__asyncProcess__Data[0][0] )

		if StringInStr($sStdOut, $endingString) Then	;look for our unique phrase to signal we're done
			$sStdOut = StringLeft($sStdOut, StringInStr($sStdOut, $endingString)-1)
			$pDone = 1
		ElseIf TimerDiff($__asyncProcess__Data[0][1]) > $__asyncProcess__Data[1][3] Then	;if timeout expired
			$sStdOut = "Command timeout"
			$pDone = 1
		Else
			$countdown = 10 - Round(TimerDiff($pRuntime)/1000)
			if $countdown <=5 Then
				$__asyncProcess__Data[0][3] = $countdown
			EndIf
		EndIf

		If $pDone Then
			$desc = $__asyncProcess__Data[1][2]
			$nextdesc = ""
			If UBound($__asyncProcess__Data) = 2 Then ;this is the last command
				$__asyncProcess__Data[0][2] = 1
			Else
				$nextdesc = $__asyncProcess__Data[2][2]
			EndIf
			ProcessClose($__asyncProcess__Data[0][0])
			$__asyncProcess__Data[0][0] = -1
			AdlibUnRegister("_asyncRun_Process")
			;Call($__asyncProcess__Data[1][1], $__asyncProcess__Data[1][2], $sStdOut)	;callback function
			$myFunc = $__asyncProcess__Data[1][1]
			$myFunc($desc, $nextdesc, $sStdOut)	;callback function
			_ArrayDelete($__asyncProcess__Data, 1)
			AdlibRegister("_asyncRun_Process", 100)
		EndIf
	ElseIf UBound($__asyncProcess__Data) > 1 Then	;if process is finished, start next command
		;Run command and end with a unique string so we know the command is finished
		$__asyncProcess__Data[0][0] = Run(@ComSpec & " /k " & $__asyncProcess__Data[1][0] & "& echo __asyncRun cmd done", "", @SW_HIDE, $STDIN_CHILD+$STDERR_MERGED)
		$__asyncProcess__Data[0][1] = TimerInit()	;start runtime timer
		$__asyncProcess__Data[0][2] = 0				;set Idle status to 0
	Else	;done processing, no commands left
		$__asyncProcess__Data[0][2] = 1			;idle status to 1
		AdlibUnRegister("_asyncRun_Process")	;only run when necessary
	EndIf
EndFunc

Func asyncRun_isIdle()
	Return $__asyncProcess__Data[0][2]
EndFunc

Func asyncRun_getNextDescription()

EndFunc

Func asyncRun_getCountdown()
	Return $__asyncProcess__Data[0][3]
EndFunc


;~ ;Incoming command: Execute or add the the Queue
;~ Func _asyncNewCmd($sCmd, $sMessage="", $addToQueue=-1)
;~ 	If not ProcessExists ( $iPID ) Then
;~ 		$sStdOut = ""
;~ 		$sStdErr = ""
;~ 		_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, False)
;~ 		ConsoleWrite($sCmd&@CRLF)
;~ 		$showWarning = 0
;~ 		;Run command and end with a unique string so we know the command is finished
;~ 		$iPID = Run(@ComSpec & " /k " & $sCmd & "& echo simple ip config cmd done", "", @SW_HIDE, $STDIN_CHILD+$STDERR_MERGED)
;~ 		$pRuntime = TimerInit()
;~ 		$pIdle = 0
;~ 		If $sMessage <> "" Then
;~ 			_setStatus($sMessage)
;~ 		EndIf
;~ 		;Sleep(500)
;~ 	ElseIf $addToQueue Then
;~ 		_asyncAddToQueue($sCmd, $sMessage)
;~ 	EndIf
;~ EndFunc

;~ ;add a new command to the Queue
;~ Func _asyncAddToQueue($sCmd, $sMessage)
;~ 	$pQueue[0][0] = $pQueue[0][0] + 1
;~ 	_ArrayAdd($pQueue, $sCmd&"|"&$sMessage)
;~ EndFunc

;~ ;check to see if any more items in the Queue
;~ Func _asyncCheckQueue()
;~ 	If $pQueue[0][0] > 0 Then
;~ 		_asyncNewCmd($pQueue[1][0], $pQueue[1][1])
;~ 		_ArrayDelete($pQueue, 1)
;~ 		$pQueue[0][0] = $pQueue[0][0] -1
;~ 	EndIf
;~ EndFunc

;~ ;delete all items in the Queue
;~ Func _asyncClearQueue()
;~ 	If $pQueue[0][0] > 0 Then
;~ 		_ArrayDelete($pQueue, "1-"&$pQueue[0][0])
;~ 		$pQueue[0][0] = 0
;~ 	EndIf
;~ EndFunc

;~ ;process the async Queue
;~ Func _asyncProcess()
;~ 	Local $dTimeout
;~ 	$pExists = ProcessExists ( $iPID )
;~ 	If $pExists Then
;~ 		$sStdOut = $sStdOut & StdoutRead($iPID)
;~ 		$sStdErr = $sStdErr & StderrRead ($iPID)

;~ 		;ConsoleWrite($sStdOut&@CRLF)
;~ 		if StringInStr($sStdOut, "simple ip config cmd done") Then	;look for our unique phrase to signal we're done
;~ 			$sStdOut = StringLeft($sStdOut, StringLen($sStdOut)-33)
;~ 			ProcessClose($iPID)
;~ 			$pDone = 1
;~ 			$iPID = -1
;~ 		ElseIf TimerDiff($pRuntime) > 10000 Then
;~ 			$dTimeout = 1
;~ 			$sStdOut = ""
;~ 			ProcessClose($iPID)
;~ 			$pDone = 1
;~ 			$iPID = -1
;~ 			ConsoleWrite("Timeout" & @CRLF)
;~ 		Else
;~ 			$countdown = 10 - Round(TimerDiff($pRuntime)/1000)
;~ 			if $countdown <=5 Then
;~ 				_setStatus($sStatusMessage & "  " & "Timeout in " & $countdown & " seconds",0,1)
;~ 			EndIf
;~ 		EndIf
;~ 	Else
;~ 		$pIdle = 1
;~ 	EndIf

;~ 	If $pDone Then
;~ 		$pDone = 0
;~ 		If $dTimeout Then
;~ 			$dTimeout = 0
;~ 			_setStatus("Action timed out!  Command Aborted.", 1)
;~ 			_asyncClearQueue()
;~ 			_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
;~ 		Else
;~ 	 		;ConsoleWrite($sStdOut&@CRLF)
;~ 			If StringInStr($sStdOut, "failed") Then
;~ 				_setStatus(StringReplace($sStdOut, @CRLF, " "), 1)
;~ 				IF $pQueue[0][0] = 0 Then
;~ 					_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
;~ 				EndIf
;~ 			Else
;~ 				IF $pQueue[0][0] = 0 Then
;~ 					_GUICtrlToolbar_EnableButton($hToolbar, $tb_apply, True)
;~ 					If not $showWarning Then _setStatus("Ready")
;~ 				EndIf
;~ 			EndIf
;~ 		EndIf
;~ 		_updateCurrent()
;~ 		_asyncCheckQueue()
;~ 	EndIf
;~ EndFunc