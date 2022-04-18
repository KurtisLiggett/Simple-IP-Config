;~ #AutoIt3Wrapper_Run_Au3Stripper=y

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


#RequireAdmin
#NoTrayIcon    ;prevent double icon when checking for already running instance

#include <WindowsConstants.au3>
#include <APIConstants.au3>
#include <WinAPI.au3>
#include <WinAPIEx.au3>
#include <GDIPlus.au3>
#include <GUIImageList.au3>
#include <GUIToolbar.au3>
#include <GuiListView.au3>
#include <GuiIPAddress.au3>
#include <GuiMenu.au3>
#include <Misc.au3>
#include <Color.au3>
#include <GUIEdit.au3>
#include <GuiComboBox.au3>
#include <Array.au3>
#include <Date.au3>
#include <Inet.au3>
#include <File.au3>

#include "libraries\AutoItObject.au3"
#include "libraries\oLinkedList.au3"
_AutoItObject_StartUp()

#Region options
Opt("TrayIconHide", 0)
Opt("GUIOnEventMode", 1)
Opt("TrayAutoPause", 0)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 3)
Opt("MouseCoordMode", 2)
Opt("GUIResizeMode", $GUI_DOCKALL)
Opt("WinSearchChildren", 1)
Opt("GUICloseOnESC", 0)
;~ Opt("MustDeclareVars", 1)
TraySetClick(16)
#EndRegion options

; autoit wrapper options
#AutoIt3Wrapper_Res_HiDpi=y
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_OutFile=Simple IP Config 2.9.4-BETA03.exe
#AutoIt3Wrapper_Res_Fileversion=2.9.4.0
#AutoIt3Wrapper_Res_Description=Simple IP Config

#Region Global Variables
Global $options
Global $profiles
Global $adapters

#include <GUIConstantsEx.au3>

; Global constants, for code readability
Global Const $wbemFlagReturnImmediately = 0x10
Global Const $wbemFlagForwardOnly = 0x20

Global $screenshot = 0
Global $sProfileName = @ScriptDir & "\profiles.ini"

;GUI stuff
Global $winName = "Simple IP Config"
Global $winVersion = "2.9.4-beta04"
Global $winDate = "4/14/2022"
Global $hgui
Global $guiWidth = 600
Global $guiHeight = 550
Global $footerHeight = 16
Global $tbarHeight = 49
Global $dscale = 1
Global $iDPI = 0

Global $headingHeight = 20
Global $menuHeight, $captionHeight
Global $MinToTray, $RestoreItem, $aboutitem, $exititem, $exititemtray

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
Global $statusChild, $RestartChild
Global $statustext, $statuserror, $sStatusMessage
Global $wgraphic, $showWarning

;Menu Items
Global $filemenu, $applyitem, $renameitem, $newitem, $saveitem, $deleteitem, $clearitem, $createLinkItem, $profilesOpenItem, $profilesImportItem, $profilesExportItem, $exititem, $netConnItem
Global $viewmenu, $refreshitem, $send2trayitem, $blacklistitem
Global $toolsmenu, $pullitem, $disableitem, $releaseitem, $renewitem, $cycleitem, $settingsitem
Global $helpmenu, $helpitem, $changelogitem, $checkUpdatesItem, $debugmenuitem, $infoitem

Global $lvcon_rename, $lvcon_delete, $lvcon_arrAz, $lvcon_arrZa, $lvcreateLinkItem

;Settings window
Global $ck_mintoTray, $ck_startinTray, $ck_saveAdapter, $ck_autoUpdate, $cmb_langSelect

Global $timerstart, $timervalue

Global $movetosubnet
Global $mdblTimerInit = 0, $mdblTimerDiff = 1000, $mdblClick = 0, $mDblClickTime = 500
Global $dragging = False, $dragitem = 0, $contextSelect = 0
Global $prevWinPos, $winPosTimer, $writePos
Global $OpenFileFlag, $ImportFileFlag, $ExportFileFlag

; CONTROLS
Global $combo_adapters, $combo_dummy, $selected_adapter, $lDescription, $lMac
Global $list_profiles, $input_filter, $filter_dummy, $dummyUp, $dummyDown
Global $lv_oldName, $lv_newName, $lv_editIndex, $lv_doneEditing, $lv_newItem, $lv_startEditing, $lv_editing, $lv_aboutEditing
Global $radio_IpAuto, $radio_IpMan, $ip_Ip, $ip_Subnet, $ip_Gateway, $dummyTab
Global $radio_DnsAuto, $radio_DnsMan, $ip_DnsPri, $ip_DnsAlt
Global $label_CurrentIp, $label_CurrentSubnet, $label_CurrentGateway
Global $label_CurrentDnsPri, $label_CurrentDnsAlt
Global $label_CurrentDhcp, $label_CurrentAdapterState
Global $link, $computerName, $domainName
Global $blacklistLV

Global $headingSelect, $headingProfiles, $headingIP, $headingCurrent
Global $label_CurrIp, $label_CurrSubnet, $label_CurrGateway, $label_CurrDnsPri, $label_CurrDnsAlt, $label_CurrDhcp, $label_CurrAdapterState
Global $label_DnsPri, $label_DnsAlt, $ck_dnsReg, $label_ip, $label_subnet, $label_gateway

; TOOLBAR
Global $hTool, $hTool2
Global $hToolbar, $hToolbar2
Global $ToolbarIDs, $Toolbar2IDs
Global Enum $tb_apply = 1000, $tb_refresh, $tb_add, $tb_save, $tb_delete, $tb_clear
Global Enum $tb_settings = 2000, $tb_tray

; LANGUAGE VARIABLES
Global $oLangStrings
#EndRegion Global Variables

#include "libraries\Json\json.au3"
#include "data\adapters.au3"
#include "data\options.au3"
#include "data\profiles.au3"
#include "hexIcons.au3"
#include "languages.au3"
#include "libraries\asyncRun.au3"
#include "libraries\StringSize.au3"
#include "libraries\Toast.au3"
#include "libraries\_NetworkStatistics.au3"
#include "functions.au3"
#include "events.au3"
#include "network.au3"
#include "forms\_form_main.au3"
#include "forms\_form_about.au3"
#include "forms\_form_changelog.au3"
#include "forms\_form_debug.au3"
#include "forms\_form_blacklist.au3"
#include "forms\_form_settings.au3"
#include "forms\_form_update.au3"
#include "forms\_form_restart.au3"
#include "cli.au3"

#Region PROGRAM CONTROL
;create the main 'objects'
$options = _Options()
$profiles = _Profiles()
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
#EndRegion PROGRAM CONTROL

;------------------------------------------------------------------------------
; Title........: _main
; Description..: initial program setup & main running loop
;------------------------------------------------------------------------------
Func _main()
	_print("starting")
	_initLang()

	_print("init lang")
	; popuplate current adapter names and mac addresses
	;_loadAdapters()

	; get current DPI scale factor
	$dscale = _GDIPlus_GraphicsGetDPIRatio()
	$iDPI = $dscale * 96

	;get profiles list
	_loadProfiles()
	_print("load profiles")

	;get OS language OR selected language storage in profile
	$selectedLang = $options.Language
	If $selectedLang <> "" And $oLangStrings.OSLang <> $selectedLang Then
		$oLangStrings.OSLang = $selectedLang
	EndIf
	If $selectedLang = "" Then
		$options.Language = $oLangStrings.OSLang
		IniWrite($sProfileName, "options", "Language", $oLangStrings.OSLang)
	EndIf

	_setLangStrings($oLangStrings.OSLang)
	_print("set lang")

	;make the GUI
	_form_main()
	_print("make GUI")

	;get list of adapters and current IP info
	_loadAdapters()
	_print("load adapters")

	;watch for new program instances
	GUIRegisterMsg($iMsg, '_NewInstance')

	;Add adapters the the combobox
	If Not IsArray($adapters) Then
		MsgBox(16, $oLangStrings.message.error, $oLangStrings.message.errorRetrieving)
	Else
		Adapter_Sort($adapters)    ; connections sort ascending
		$defaultitem = Adapter_GetName($adapters, 0)
		$sStartupAdapter = $options.StartupAdapter
		If Adapter_Exists($adapters, $sStartupAdapter) Then
			$defaultitem = $sStartupAdapter
		EndIf

		$sAdapterBlacklist = $options.AdapterBlacklist
		$aBlacklist = StringSplit($sAdapterBlacklist, "|")
		If IsArray($aBlacklist) Then
			Local $adapterNames = Adapter_GetNames($adapters)
			For $i = 0 To UBound($adapterNames) - 1
				$indexBlacklist = _ArraySearch($aBlacklist, $adapterNames[$i], 1)
				If $indexBlacklist <> -1 Then ContinueLoop
				GUICtrlSetData($combo_adapters, $adapterNames[$i], $defaultitem)
			Next
		EndIf
	EndIf

	_refresh(1)
	ControlListView($hgui, "", $list_profiles, "Select", 0)

	;get system double-click time
	$retval = DllCall('user32.dll', 'uint', 'GetDoubleClickTime')
	$mDblClickTime = $retval[0]

	;see if we should display the changelog
	_checkChangelog()

	;get the domain
	GUICtrlSetData($domainName, _DomainComputerBelongs())

	$sAutoUpdate = $options.AutoUpdate
	If ($sAutoUpdate = "true" Or $sAutoUpdate = "1") Then
		$suppressComError = 1
		_checksSICUpdate()
		$suppressComError = 0
	EndIf

	Local $filePath
	_print("Running")
	While 1
		If $lv_doneEditing Then
			_onLvDoneEdit()
		EndIf

		If $lv_startEditing And Not $lv_editing Then
			_onRename()
		EndIf

		If $movetosubnet Then
			_MoveToSubnet()
		EndIf

		If $OpenFileFlag Then
			$OpenFileFlag = 0
			$filePath = FileOpenDialog($oLangStrings.dialog.selectFile, @ScriptDir, $oLangStrings.dialog.ini & " (*.ini)", $FD_FILEMUSTEXIST, "profiles.ini")
			If Not @error Then
				$sProfileName = $filePath
				$options = _Options()
				$profiles = _Profiles()
				_refresh(1)
				_setStatus($oLangStrings.message.loadedFile & " " & $filePath, 0)
			EndIf
		EndIf

		If $ImportFileFlag Then
			$ImportFileFlag = 0
			$filePath = FileOpenDialog($oLangStrings.dialog.selectFile, @ScriptDir, $oLangStrings.dialog.ini & " (*.ini)", $FD_FILEMUSTEXIST, "profiles.ini")
			If Not @error Then
				_ImportProfiles($filePath)
				_refresh(1)
				_setStatus($oLangStrings.message.doneImporting, 0)
			EndIf
		EndIf

		If $ExportFileFlag Then
			$ExportFileFlag = 0
			$filePath = FileSaveDialog($oLangStrings.dialog.selectFile, @ScriptDir, $oLangStrings.dialog.ini & " (*.ini)", $FD_PROMPTOVERWRITE, "profiles.ini")
			If Not @error Then
				If StringRight($filePath, 4) <> ".ini" Then
					$filePath &= ".ini"
				EndIf
				FileCopy($sProfileName, $filePath, $FC_OVERWRITE)
				_setStatus($oLangStrings.message.fileSaved & ": " & $filePath, 0)
			EndIf
		EndIf

		Sleep(100)
	WEnd
EndFunc   ;==>_main

;------------------------------------------------------------------------------
; Title........: _NewInstance
; Description..: Called when a new program instance posts the message we were watching for.
;                Bring the running program instance to the foreground.
;------------------------------------------------------------------------------
Func _NewInstance($hWnd, $iMsg, $iwParam, $ilParam)
	If $iwParam == "0x00000101" Then
;~ 		TrayTip("", "Simple IP Config is already running", 1)

;~ 		$sMsg  = 'Simple IP Config is already running'
;~ 		_Toast_Set(0, 0xAAAAAA, 0x000000, 0xFFFFFF, 0x000000, 10, "", 250, 250)
;~ 		$aRet = _Toast_Show(0, "Simple IP Config", $sMsg, -5, False) ; Delay can be set here because script continues

		_maximize()
	EndIf
EndFunc   ;==>_NewInstance
