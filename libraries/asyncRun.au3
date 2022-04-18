#include-once
;==============================================================================
; Filename:		asyncRun.au3
; Description:	Run command 'asynchronously', then execute a callback function.
;               Chain commands to run after the previous command finishes.
; Author:       Kurtis Liggett
;==============================================================================

Global $iPID = -1, $pRuntime
Global $pRunning, $pDone, $sStdOut, $sStdErr, $pIdle = 1
Global $pQueue[1][2] = [[0, 0]]

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

Func asyncRun($sCmd, $CallbackFunc, $sDescription = "", $iTimeout = 10000)
	_ArrayAdd($__asyncProcess__Data, $sCmd)
	Local $size = UBound($__asyncProcess__Data)
	$__asyncProcess__Data[$size - 1][1] = $CallbackFunc
	$__asyncProcess__Data[$size - 1][2] = $sDescription
	$__asyncProcess__Data[$size - 1][3] = $iTimeout
	$__asyncProcess__Data[0][2] = 0
	If $size = 2 Then
		$sStdOut = ""
		_setStatus("")
		$CallbackFunc($sDescription, $sDescription, "")
	EndIf
	AdlibRegister("_asyncRun_Process", 100)
EndFunc   ;==>asyncRun

Func _asyncRun_Execute($sCmd)

EndFunc   ;==>_asyncRun_Execute

Func _asyncRun_Clear()
	For $i = 1 To UBound($__asyncProcess__Data) - 1
		_ArrayDelete($__asyncProcess__Data, 1)
	Next
EndFunc   ;==>_asyncRun_Clear

Func _asyncRun_Process()
	Local $endingString = "__asyncRun cmd done"

	Local $pExists = ProcessExists($__asyncProcess__Data[0][0])
	If $pExists Then    ;if process exists, check if finished
		Local $pDone

		$sStdOut = $sStdOut & StdoutRead($__asyncProcess__Data[0][0])
		$sStdErr = $sStdErr & StderrRead($__asyncProcess__Data[0][0])

		If StringInStr($sStdOut, $endingString) Then    ;look for our unique phrase to signal we're done
			$sStdOut = StringLeft($sStdOut, StringInStr($sStdOut, $endingString) - 1)
			$pDone = 1
		ElseIf TimerDiff($__asyncProcess__Data[0][1]) > $__asyncProcess__Data[1][3] Then    ;if timeout expired
			$sStdOut = "Command timeout"
			$pDone = 1
		Else
			Local $countdown = 10 - Round(TimerDiff($pRuntime) / 1000)
			If $countdown <= 5 Then
				$__asyncProcess__Data[0][3] = $countdown
			EndIf
		EndIf

		If $pDone Then
			Local $desc = $__asyncProcess__Data[1][2]
			Local $nextdesc = ""
			If UBound($__asyncProcess__Data) = 2 Then ;this is the last command
				$__asyncProcess__Data[0][2] = 1
			Else
				$nextdesc = $__asyncProcess__Data[2][2]
			EndIf
			ProcessClose($__asyncProcess__Data[0][0])
			$__asyncProcess__Data[0][0] = -1
			AdlibUnRegister("_asyncRun_Process")
			;Call($__asyncProcess__Data[1][1], $__asyncProcess__Data[1][2], $sStdOut)	;callback function
			Local $myFunc = $__asyncProcess__Data[1][1]
			$myFunc($desc, $nextdesc, $sStdOut)    ;callback function
			_ArrayDelete($__asyncProcess__Data, 1)
			AdlibRegister("_asyncRun_Process", 100)
		EndIf
	ElseIf UBound($__asyncProcess__Data) > 1 Then    ;if process is finished, start next command
		;Run command and end with a unique string so we know the command is finished
		$__asyncProcess__Data[0][0] = Run(@ComSpec & " /k " & $__asyncProcess__Data[1][0] & "& echo __asyncRun cmd done", "", @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
		$__asyncProcess__Data[0][1] = TimerInit()    ;start runtime timer
		$__asyncProcess__Data[0][2] = 0                ;set Idle status to 0
	Else    ;done processing, no commands left
		$__asyncProcess__Data[0][2] = 1            ;idle status to 1
		AdlibUnRegister("_asyncRun_Process")    ;only run when necessary
	EndIf
EndFunc   ;==>_asyncRun_Process

Func asyncRun_isIdle()
	Return $__asyncProcess__Data[0][2]
EndFunc   ;==>asyncRun_isIdle

Func asyncRun_getNextDescription()

EndFunc   ;==>asyncRun_getNextDescription

Func asyncRun_getCountdown()
	Return $__asyncProcess__Data[0][3]
EndFunc   ;==>asyncRun_getCountdown
