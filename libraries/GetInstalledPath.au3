; #FUNCTION# ====================================================================================================================
; Name...........: _GetInstalledPath
; Description ...: Returns the installed path for specified program
; Syntax.........: GetInstalledPath($sProgamName)
; Parameters ....: $sProgamName    - Name of program to seaach for
;                                   - Must be exactly as it appears in the registry unless extended search is used
;                   $sDisplayName - Returns the "displayName" key from for the program (can be used to check you have the right program)
;                   $fExtendedSearchFlag - True - Search for $sProgamName in "DisplayName" Key
;                   $fSlidingSearch - True - Find $sProgamName anywhere in "DisplayName" Key
;                                    False - Must be exact match
; Return values .: Success     - returns the install path
;                            -
;                  Failure - 0
;                  |@Error  - 1 = Unable to find entry in registry
;                  |@Error  - 2 = No "InstalledLocation" key
; Author ........: John Morrison aka Storm-E
; Remarks .......: V1.5 Added scan for $sProgamName in "DisplayName" Thanks to JFX for the idea
;                : V1.6 Fix for 64bit systems
;                : V2     Added      support for multiple paths (32,64&Wow6432Node) for uninstall key
;                 :                returns display name for the program (script breaking change)
;                 :                If the Uninstall key is not found it now uses the path from "DisplayIcon" key (AutoitV3 doesn't have an Uninstall Key)
; Related .......:
; Link ..........:
; Example .......: Yes
; AutoIT link ...; http://www.autoitscript.com/forum/topic/139761-getinstalledpath-from-uninstall-key-in-registry/
; ===============================================================================================================================
Func _GetInstalledPath($sProgamName, ByRef $sDisplayName, $fExtendedSearchFlag = True, $fSlidingSearch = True)

    ;Using WMI : Why I diddn't use "Win32_Product" instead of the reg searching.
    ;http://provincialtech.com/wordpress/2012/05/15/wmi-win32_product-vs-win32_addremoveprograms/

    Local $asBasePath[3] = ["hklm\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\", "hklm64\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\", "hklm\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\"]
    Local $sBasePath ; base for registry search
    Local $sCurrentKey ; Holds current key during search
    Local $iCurrentKeyIndex ; Index to current key
    Local $iErrorCode = 0 ; Store return error code
    Local $sInstalledPath = "" ; the found installed path

    $iErrorCode = 0
    For $sBasePath In $asBasePath
        $sInstalledPath = RegRead($sBasePath & $sProgamName, "InstallLocation")
        If @error = -1 Then
            ;Unable To open "InstallLocation" key so try "DisplayIcon"
            ;"DisplayIcon" is usually the main EXE so should be the install path
            $sInstalledPath = RegRead($sBasePath & $sProgamName, "DisplayIcon")
            If @error = -1 Then
                ; Unable to find path so give-up
                $iErrorCode = 2 ; Path Not found
                $sInstalledPath = ""
                $sDisplayName = ""
            Else
                $sDisplayName = RegRead($sBasePath & $sProgamName, "DisplayName")
                $sInstalledPath = StringLeft($sInstalledPath, StringInStr($sInstalledPath, "\", 0, -1))
            EndIf
        EndIf
        If $sInstalledPath <> "" Then
            ExitLoop
        EndIf
    Next

    If $sInstalledPath = "" Then
        ; Didn't find path by direct key request so try a search
        ;Key not found
        $iErrorCode = 0;
        If $fExtendedSearchFlag Then
            For $sBasePath In $asBasePath
                $iCurrentKeyIndex = 1 ;reset for next run
                While $fExtendedSearchFlag
                    $sCurrentKey = RegEnumKey($sBasePath, $iCurrentKeyIndex)
                    If @error Then
                        ;No keys left
                        $iErrorCode = 1 ; Path Not found
                        ExitLoop
                    Else
                        $sDisplayName = RegRead($sBasePath & $sCurrentKey, "DisplayName")
                    EndIf

                    If ($fSlidingSearch And StringInStr($sDisplayName, $sProgamName)) Or ($sDisplayName = $sProgamName) Then
                        ;Program name found in DisplayName
                        $sInstalledPath = RegRead($sBasePath & $sCurrentKey , "InstallLocation")
                        If @error Then
                            ;Unable To open "InstallLocation" key so try "DisplayIcon"
                            ;"DisplayIcon" is usually the main EXE so should be the install path
                            $sInstalledPath = RegRead($sBasePath & $sCurrentKey, "DisplayIcon")
                            If @error = -1 Then
                                ; Unable to find path so give-up
                                $iErrorCode = 2 ; Path Not found
                                $sInstalledPath = ""
                                $sDisplayName = ""
                            Else
                                $sInstalledPath = StringLeft($sInstalledPath, StringInStr($sInstalledPath, "\", 0, -1))
                            EndIf
                            ExitLoop
                        EndIf
                        ExitLoop
                    EndIf
                    $iCurrentKeyIndex += 1
                WEnd
                If $sInstalledPath <> "" Then
                    ; Path found so stop looking
                    ExitLoop
                EndIf
            Next
        Else
            $sDisplayName = ""
            Return SetError(1, 0, "") ; Path Not found
        EndIf
    Else
        Return $sInstalledPath
    EndIf

    If $sInstalledPath = "" Then
        ; program not found
        $sDisplayName = ""
        Return SetError($iErrorCode, 0, "")
    Else
        Return $sInstalledPath
    EndIf
EndFunc   ;==>_GetInstalledPath