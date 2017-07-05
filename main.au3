;#AutoIt3Wrapper_Run_Au3Stripper=y

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
; Filename:		main.au3
; Description:	- call functions to read profiles, get adapters list, create the gui
;				- while loop to keep program running
;				- check for instance already running
;==============================================================================


;==============================================================================
;
; Name:    		 Simple IP Config
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

;create a new window message
Global $iMsg = _WinAPI_RegisterWindowMessage('newinstance_message')

;check to see if another instance is already running
If _Singleton("Simple IP Config", 1) = 0 Then
	;alert existing program instances of the new instance, then exit
	_WinAPI_PostMessage(0xffff, $iMsg, 0x101, 0)
    Exit
EndIf

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

#include "globals.au3"
#include "hexIcons.au3"
#include "network.au3"
#include "libraries\StringSize.au3"
#include "libraries\_NetworkStatistics.au3"
#include "functions.au3"
#include "events.au3"
#include "gui.au3"

Opt("TrayIconHide", 0)
Opt("GUIOnEventMode",1)
Opt("TrayAutoPause",0)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",3)
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


;------------------------------------------------------------------------------
; Title........: _main
; Description..: initial program setup & main running loop
;------------------------------------------------------------------------------
Func _main()
	; popuplate current adapter names and mac addresses
	;_loadAdapters()

	; get current DPI scale factor
	$dScale = _GDIPlus_GraphicsGetDPIRatio()
	$iDPI = $dScale * 96

	;get profiles list
	_loadProfiles()

	;make the GUI
	_makeGUI()

	;get list of adapters and current IP info
	_loadAdapters()

	;watch for new program instances
	GUIRegisterMsg($iMsg, '_NewInstance')

	;Add adapters the the combobox
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

	;see if we should display the changelog
	_checkChangelog()

	;get the domain
	GUICtrlSetData($domain, _DomainComputerBelongs())

	;wait for user interaction (events)
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

;------------------------------------------------------------------------------
; Title........: _NewInstance
; Description..: Called when a new program instance posts the message we were watching for.
;                Display a tray tooltip alerting the user that the program is already running.
;------------------------------------------------------------------------------
Func _NewInstance($hWnd, $iMsg, $iwParam, $ilParam)
	if $iwParam == "0x00000101" Then
		TrayTip("", "Simple IP Config is already running", 1)
	EndIf
EndFunc