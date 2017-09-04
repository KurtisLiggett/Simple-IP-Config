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
#NoTrayIcon	;prevent double icon when checking for already running instance


#Region Global Variables
Global $options
Global $profiles
Global $adapters

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
Global $winVersion = "2.9.b1"
Global $winDate = "09/04/2017"
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
Global $ck_mintoTray, $ck_startinTray, $ck_saveAdapter, $ck_autoUpdate

Global $timerstart, $timervalue

Global $movetosubnet
Global $mdblTimerInit=0, $mdblTimerDiff=1000, $mdblClick = 0, $mDblClickTime=500
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

#include "model.au3"
#include "hexIcons.au3"
#include "libraries\asyncRun.au3"
#include "libraries\StringSize.au3"
#include "libraries\Toast.au3"
#include "libraries\_NetworkStatistics.au3"
#include "functions.au3"
#include "events.au3"
#include "network.au3"
#include "gui.au3"
#include "cli.au3"
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
#AutoIt3Wrapper_OutFile=Simple IP Config 2.9.b1.exe
#AutoIt3Wrapper_Res_Fileversion=2.9.0.1
#AutoIt3Wrapper_Res_Description=Simple IP Config

#Region PROGRAM CONTROL
;create the main 'objects'
$options = Options()
$profiles = Profiles()
$adapters = Adapter()

;check to see if called with command line arguments
CheckCmdLine()

;create a new window message
Global $iMsg = _WinAPI_RegisterWindowMessage('newinstance_message')

;Check if already running. If running, send a message to the first
;instance to show a popup message then close this instance.
If _Singleton("Simple IP Config", 1) = 0 Then
	_WinAPI_PostMessage(0xffff, $iMsg, 0x101, 0)
    Exit
EndIf

;begin main program
_main()
#EndRegion

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
		Adapter_Sort($adapters)	; connections sort ascending
		$defaultitem = Adapter_GetName($adapters, 0)
		$sStartupAdapter = OPTIONS_GetValue($options, $OPTIONS_StartupAdapter)
		If Adapter_Exists($adapters, $sStartupAdapter) Then
			$defaultitem = $sStartupAdapter
		EndIf

		$sAdapterBlacklist = OPTIONS_GetValue($options, $OPTIONS_AdapterBlacklist)
		$aBlacklist = StringSplit($sAdapterBlacklist, "|")
		If IsArray($aBlacklist) Then
			Local $adapterNames = Adapter_GetNames($adapters)
			For $i=0 to UBound($adapterNames)-1
				$indexBlacklist = _ArraySearch($aBlacklist, $adapterNames[$i], 1)
				if $indexBlacklist <> -1 Then ContinueLoop
				GUICtrlSetData( $combo_adapters, $adapterNames[$i], $defaultitem )
			Next
		EndIf
	EndIf

	_refresh(1)
	ControlListView( $hgui, "", $list_profiles, "Select", 0 )

	;get system double-click time
	$retval = DllCall('user32.dll', 'uint', 'GetDoubleClickTime')
	$mDblClickTime = $retval[0]

	;see if we should display the changelog
	_checkChangelog()

	;get the domain
	GUICtrlSetData($domain, _DomainComputerBelongs())

	$sAutoUpdate = OPTIONS_GetValue($options, $OPTIONS_AutoUpdate)
	if($sAutoUpdate = "true" OR $sAutoUpdate = "1") Then
		_checksSICUpdate()
	EndIf

	While 1
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
		;TrayTip("", "Simple IP Config is already running", 1)
		$sMsg  = 'Simple IP Config is already running'
		_Toast_Set(0, 0xAAAAAA, 0x000000, 0xFFFFFF, 0x000000, 10, "", 250, 250)
		$aRet = _Toast_Show(0, "Simple IP Config", $sMsg, -5, False) ; Delay can be set here because script continues
	EndIf
EndFunc
