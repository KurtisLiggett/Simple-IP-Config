; -----------------------------------------------------------------------------
; This file is part of Simple IP Config.
;
; Simple IP Config is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; Simple IP Config is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with Simple IP Config.  If not, see <http://www.gnu.org/licenses/>.
;
;
; The CLI commands:
;
; Command:    /set-config
; Params:     "profile name"
; -----------------------------------------------------------------------------

Global $cmdLine
If $CMDLINE[0] Then
  If (UBound($CMDLINE) = 3) Then
    Switch $CMDLINE[1]
		Case '/set-config'
			$profileName = $CMDLINE[2]
          ; Code for configuration
          _loadProfiles()
          ; Let's check if the profile name exists
          For $i = 1 To UBound($profilelist) -1
            If($profilelist[$i][0] == $profileName) Then
				$cmdLine = 1
				$sMsg  = 'Applying profile "' & $profileName & '"...'
				_Toast_Set(0, 0xAAAAAA, 0x000000, 0xFFFFFF, 0x000000, 10, "", 250, 250)
				$aRet = _Toast_Show(0, "Simple IP Config", $sMsg, 0, False) ; Delay can be set here because script continues
              _apply(($profilelist[$i][1])[0], ($profilelist[$i][1])[1], ($profilelist[$i][1])[2], ($profilelist[$i][1])[3], ($profilelist[$i][1])[4], ($profilelist[$i][1])[5], ($profilelist[$i][1])[6], ($profilelist[$i][1])[7], ($profilelist[$i][1])[8])
			  _cmdLineMain($profileName)
			EndIf
		  Next
			$sMsg  = 'The profile "' & $profileName & '" could not be found.'
			_Toast_Set(0, 0xFF0000, 0xFFFFFF, 0xFFFFFF, 0x000000, 10, "", 250, 250)
			$aRet = _Toast_Show(0, "Simple IP Config", $sMsg, -3, True) ; Delay can be set here because script continues

        Case Else
          Exit
    EndSwitch
    Exit
  Else
	$sMsg  = "Incorrect number of parameters."
	_Toast_Set(0, 0xFF0000, 0xFFFFFF, 0xFFFFFF, 0x000000, 10, "", 250, 250)
	$aRet = _Toast_Show(0, "Simple IP Config", $sMsg, -3, True) ; Delay can be set here because script continues
    Exit
  EndIf
EndIf

If _Singleton("Simple IP Config", 1) = 0 Then
	_WinAPI_PostMessage(0xffff, $iMsg, 0x101, 0)
    Exit
EndIf

Func _cmdLineMain($profileName)
	While 1
		If Not $pIdle Then
			_asyncProcess()
		Else
			_Toast_Hide()
			If StringInStr($sStdOut, "failed") Then
				$sMsg  = 'An error occurred while applying the profile "' & $profileName & '".' &@CRLF&@CRLF&$sStdOut
				_Toast_Set(0, 0xFF0000, 0xFFFFFF, 0xFFFFFF, 0x000000, 10, "", 250, 250)
				$aRet = _Toast_Show(0, "Simple IP Config", $sMsg, -7, True) ; Delay can be set here because script continues
			Else
				$sMsg  = 'Profile "' & $profileName & '" applied successfully.'
				_Toast_Set(0, 0xAAAAAA, 0x000000, 0xFFFFFF, 0x000000, 10, "", 250, 250)
				$aRet = _Toast_Show(0, "Simple IP Config", $sMsg, 2, True) ; Delay can be set here because script continues
			EndIf

			Exit
		EndIf
		Sleep(100)
	WEnd
EndFunc
