#AutoIt3Wrapper_Run_Au3Stripper=y

; -----------------------------------------------------------------------------
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
; -----------------------------------------------------------------------------

;==============================================================================
;
; Name:    		 Simple IP Config
;
; Date:			 06/29/2017
;
; Description:   Simple IP Config is a program for Windows to easily change
;				 various network settings in a format similar to the
;				 built-in Windows configuration.
;
; Required OS:   Windows XP, Windows Vista, Windows 7, Windows 8, Window 8.1, Windows 10
;
; Author:      	 Kurtis Liggett
;
;==============================================================================

#requireadmin
#NoTrayIcon	;prevent double icon for singleton check

Global $iMsg = _WinAPI_RegisterWindowMessage('newinstance_message')

#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <APIConstants.au3>
#include <WinAPI.au3>
#Include <WinAPIEx.au3>
#include <GDIPlus.au3>
#Include <GUIImageList.au3>
#Include <GUIToolbar.au3>
#include <GuiListView.au3>
#include <GuiIPAddress.au3>
#include <GuiMenu.au3>
#include <Misc.au3>
#include <Color.au3>
#Include <GUIEdit.au3>
#include <GuiComboBox.au3>
#include <Array.au3>
;~ #include <AutoItConstants.au3>

#include "globals.au3"
#include "hexIcons.au3"
#include "network.au3"
#include "libraries\StringSize.au3"
#include "libraries\Toast.au3"
#include "libraries\_NetworkStatistics.au3"
#include "functions.au3"
#include "events.au3"
#include "gui.au3"
#include "cli.au3"

Opt("TrayIconHide", 0)
Opt("GUIOnEventMode",1)
Opt("TrayAutoPause",0)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",3)
;Opt("MustDeclareVars", 1)
Opt("MouseCoordMode", 2)
Opt("GUIResizeMode", $GUI_DOCKALL)
Opt("WinSearchChildren",1)
TraySetClick(16)


; autoit wrapper options
#AutoIt3Wrapper_Res_HiDpi=y
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_OutFile=Simple IP Config 2.8.1.exe
#AutoIt3Wrapper_Res_Fileversion=2.8.1
#AutoIt3Wrapper_Res_Description=Simple IP Config

Global $timerstart, $timervalue

; BEGIN MAIN PROGRAM
_main()

Func _main()
	;$objWMI = ObjGet("winmgmts:\\localhost\root\CIMV2")
	$objWMI = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
;~ 	If Not IsObj($objWMI) Then
;~ 		MsgBox(16,"WMI ERROR", "This program requires the Windows Management Instrumentation (WMI) to run properly. Check to make sure it is enabled.")
;~ 	EndIf

	; popuplate current adapter names and mac addresses
	;_loadAdapters()

	; get current DPI scale factor
	$dScale = _GDIPlus_GraphicsGetDPIRatio()
	$iDPI = $dScale * 96
	;$dScale = _getDpiScale()

	_loadProfiles()
	_makeGUI()
	; build the GUI
	_loadAdapters()

	GUIRegisterMsg($iMsg, '_NewInstance')


;~ 	_setStatus("Updating adapter list...")

	If NOT IsArray( $adapters ) Then
		MsgBox( 16, "Error", "There was a problem retrieving the adapters." )
	Else
		_ArraySort($adapters, 0)	; connections sort ascending
		$defaultitem = $adapters[1][0]
		$index = _ArraySearch( $adapters, $options[4][1], 1 )
		If ($index <> -1) Then
			$defaultitem = $adapters[$index][0]
		EndIf

		$aBlacklist = StringSplit($options[7][1], "|")
		For $i=1 to $adapters[0][0]
			$indexBlacklist = _ArraySearch($aBlacklist, $adapters[$i][0], 1)
			if $indexBlacklist <> -1 Then ContinueLoop
			GUICtrlSetData( $combo_adapters, $adapters[$i][0], $defaultitem )
		Next
	EndIf

	_refresh(1)
	ControlListView( $hgui, "", $list_profiles, "Select", 0 )
;~ 	if $profilelist[0][0]>=1 Then
;~ 		_setProperties()
;~ 	EndIf
	_checkChangelog()

	GUICtrlSetData($domain, _DomainComputerBelongs())

  if($options[10][1] = "true") Then
    _checksSICUpdate()
  EndIf

	While 1
		If Not $pIdle Then _asyncProcess()

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				_onExit()
		EndSwitch

		If $lv_doneEditing Then
			_onLvDoneEdit()
		EndIf


		If $lv_startEditing and Not $lv_editing Then
			_onRename()
		EndIf

		If $movetosubnet Then
			_MoveToSubnet()
		EndIf

		Sleep(100)
	WEnd
EndFunc ; main()


Func _NewInstance($hWnd, $iMsg, $iwParam, $ilParam)
	if $iwParam == "0x00000101" Then
		TrayTip("", "Simple IP Config is already running", 1)
	EndIf
EndFunc
