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
; Command:    @set-config
; Params:     "profile name"
; -----------------------------------------------------------------------------


If $CMDLINE[0] Then
  If (UBound($CMDLINE) = 3) Then
    Switch $CMDLINE[1]
        Case 'set-config'
          ; Code for configuration
          _loadProfiles()
          ; Let's check if the profile name exists
          For $i = 1 To UBound($profilelist) -1
            If($profilelist[$i][0] == $CMDLINE[2]) Then
              _apply(($profilelist[$i][1])[0], ($profilelist[$i][1])[1], ($profilelist[$i][1])[2], ($profilelist[$i][1])[3], ($profilelist[$i][1])[4], ($profilelist[$i][1])[5], ($profilelist[$i][1])[6], ($profilelist[$i][1])[7], ($profilelist[$i][1])[8])
              Exit
            Else
              MsgBox(16, "Profile not found", "The profile you applied is no longer available")
            EndIf
          Next

        Case Else
          Exit
    EndSwitch
    Exit
  Else
    MsgBox(16, "Wrong parameters", "Wrong parameters number")
    Exit
  EndIf
EndIf

If _Singleton("Simple IP Config", 1) = 0 Then
	_WinAPI_PostMessage(0xffff, $iMsg, 0x101, 0)
    Exit
EndIf
