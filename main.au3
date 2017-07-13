#AutoIt3Wrapper_Run_Au3Stripper=y

#Region license
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
#EndRegion license

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

#Region Single instance check

#NoTrayIcon	;prevent double icon for singleton check
;create a new window message
Global $iMsg = _WinAPI_RegisterWindowMessage('newinstance_message')

;check to see if another instance is already running
If _Singleton("Simple IP Config", 1) = 0 Then
	;alert existing program instances of the new instance, then exit
	_WinAPI_PostMessage(0xffff, $iMsg, 0x101, 0)
    Exit
EndIf

#EndRegion Single instance check

#Region Global Variables
#include <GUIConstantsEx.au3>

; Global constants, for code readability
Global Const $WIN_STATE_EXISTS = 1 ; Window exists
Global Const $WIN_STATE_VISIBLE = 2 ; Window is visible
Global Const $WIN_STATE_ENABLED = 4 ; Window is enabled
Global Const $WIN_STATE_ACTIVE = 8 ; Window is active
Global Const $WIN_STATE_MINIMIZED = 16 ; Window is minimized
Global Const $WIN_STATE_MAXIMIZED = 32 ; Window is maximized
Global Const $wbemFlagReturnImmediately = 0x10
Global Const $wbemFlagForwardOnly = 0x20

Global $screenshot=0

;GUI stuff
Global $winName = "Simple IP Config"
Global $winVersion = "2.8.1"
Global $winDate = "06/29/2017"
Global $hgui
Global $guiWidth = 550
Global $guiHeight = 550
Global $footerHeight = 16
Global $tbarHeight = 49
Global $dscale = 1
Global $iDPI = 0

Global $headingHeight = 20
Global $menuHeight, $captionHeight
Global $MinToTray, $RestoreItem

Global $aAccelKeys[12][2]

;GUI Fonts
Global $MyGlobalFontName = "Arial"
Global $MyGlobalFontSize = 9.5
Global $MYGlobalFontSizeLarge = 11
Global $MyGlobalFontColor = 0x000000
Global $MyGlobalFontBKColor = $GUI_BKCOLOR_TRANSPARENT
Global $MyGlobalFontHeight = 0

;Statusbar
Global $statusbarHeight = 20
Global $statusChild
Global $statustext, $statuserror, $sStatusMessage
Global $wgraphic, $showWarning

;Menu Items
Global $toolsmenu, $disableitem, $refreshitem, $renameitem, $deleteitem, $clearitem
Global $saveitem, $newitem, $pullitem, $send2trayitem, $helpitem, $debugmenuitem

;Settings window
Global $ck_mintoTray, $ck_startinTray, $ck_saveAdapter

Global $timerstart, $timervalue

Global $movetosubnet
Global $mdblTimerInit=0, $mdblTimerDiff=1000, $mdblcheck=0, $mdblClick = 0
Global $dragging = False, $dragitem = 0, $contextSelect = 0
Global $prevWinPos, $winPosTimer, $writePos


; CONTROLS
Global $combo_adapters, $combo_dummy, $selected_adapter, $lDescription, $lMac
Global $list_profiles, $input_filter, $filter_dummy, $dummyUp, $dummyDown
Global $lv_oldName, $lv_newName, $lv_editIndex, $lv_doneEditing, $lv_newItem, $lv_startEditing, $lv_editing, $lv_aboutEditing
Global $radio_IpAuto, $radio_IpMan, $ip_Ip, $ip_Subnet, $ip_Gateway, $dummyTab
Global $label_ip, $label_subnet, $label_gateway
Global $radio_DnsAuto, $radio_DnsMan, $ip_DnsPri, $ip_DnsAlt, $ck_dnsReg
Global $label_DnsPri, $label_DnsAlt
Global $label_CurrentIp, $label_CurrentSubnet, $label_CurrentGateway
Global $label_CurrentDnsPri, $label_CurrentDnsAlt
Global $label_CurrentDhcp, $label_CurrentAdapterState, $domain
Global $link
Global $blacklistEdit, $bt_BlacklistAdd

; TOOLBAR
Global $hTool, $hTool2
Global $hToolbar, $hToolbar2
Global $ToolbarIDs, $Toolbar2IDs
Global Enum $tb_apply = 1000, $tb_refresh, $tb_add, $tb_save, $tb_delete, $tb_clear
Global Enum $tb_settings = 2000, $tb_tray


; Adapters
Global $adapters[1][4] = [[0,0,0]]	; [0]-name, [1]-mac, [2]-description, [3]-GUID
Global $profilelist[1][2]
Global $options[10][2]
$options[0][0] = "Version"
$options[1][0] = "MinToTray"
$options[2][0] = "StartupMode"
$options[3][0] = "Language"
$options[4][0] = "StartupAdapter"
$options[5][0] = "Theme"
$options[6][0] = "SaveAdapterToProfile"
$options[7][0] = "AdapterBlacklist"
$options[8][0] = "PositionX"
$options[8][1] = ""
$options[9][0] = "PositionY"
$options[9][1] = ""

Global $propertyFormat[9]
$propertyFormat[0] = "IpAuto"
$propertyFormat[1] = "IpAddress"
$propertyFormat[2] = "IpSubnet"
$propertyFormat[3] = "IpGateway"
$propertyFormat[4] = "DnsAuto"
$propertyFormat[5] = "IpDnsPref"
$propertyFormat[6] = "IpDnsAlt"
$propertyFormat[7] = "RegisterDns"
$propertyFormat[8] = "AdapterName"

#EndRegion Global Variables

#Region includes
#include <WindowsConstants.au3>
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

#include "hexIcons.au3"
#include "libraries\StringSize.au3"
#include "libraries\_NetworkStatistics.au3"
#include "asyncProcess.au3"
#include "functions.au3"
#include "events.au3"
#include "network.au3"
#include "gui.au3"
#EndRegion includes

#Region options
Opt("TrayIconHide", 0)
Opt("GUIOnEventMode",1)
Opt("TrayAutoPause",0)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",3)
Opt("MouseCoordMode", 2)
Opt("GUIResizeMode", $GUI_DOCKALL)
Opt("WinSearchChildren",1)
TraySetClick(16)
#EndRegion options

; autoit wrapper options
#AutoIt3Wrapper_Res_HiDpi=y
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_OutFile=Simple IP Config 2.8.1.exe
#AutoIt3Wrapper_Res_Fileversion=2.8.1
#AutoIt3Wrapper_Res_Description=Simple IP Config

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
	$adapters = _loadAdapters()

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