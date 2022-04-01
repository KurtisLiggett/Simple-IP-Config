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
; -----------------------------------------------------------------------------

Func _initLang()
	;create object for language strings
	$oLangStrings = IDispatch()

	;main menu
	$oLangStrings.menu = IDispatch()
	$oLangStrings.menu.file = IDispatch()
	$oLangStrings.menu.view = IDispatch()
	$oLangStrings.menu.tools = IDispatch()
	$oLangStrings.menu.help = IDispatch()
	$oLangStrings.traymenu = IDispatch()
	$oLangStrings.lvmenu = IDispatch()	;listview menu
	$oLangStrings.toolbar = IDispatch()
	$oLangStrings.interface = IDispatch()
	$oLangStrings.settings = IDispatch()
	$oLangStrings.about = IDispatch()
	$oLangStrings.messages = IDispatch()

	;format OS language
	Switch @OSLang
		Case "0409"
			$oLangStrings.OSLang = "en-US"
		Case "0410"
			$oLangStrings.OSLang = "it-IT"
		Case Else
			$oLangStrings.OSLang = "en-US"
	EndSwitch
EndFunc   ;==>_initLang

Func _getLangStringID($sLang)
	Local $retVal = -1
	Switch $sLang
		Case "English"
			$retVal = "en-US"
		Case "Italiano"
			$retVal = "it-IT"
		Case Else
			$retVal = -1
	EndSwitch
	return $retVal
EndFunc

func _setLangStrings($manualUpdate = False)
	Switch $oLangStrings.OSLang
		Case "en-US"
			_setLangEnglish()
		Case "it-IT"
			_setLangItalian()
		Case Else
			_setLangEnglish()
	EndSwitch

	If $manualUpdate Then _updateLang()
EndFunc

Func _updateLang()
	GUICtrlSetData($filemenu, $oLangStrings.menu.file.file)
	GUICtrlSetData($applyitem, $oLangStrings.menu.file.apply)
	GUICtrlSetData($renameitem, $oLangStrings.menu.file.rename)
	GUICtrlSetData($newitem, $oLangStrings.menu.file.new)
	GUICtrlSetData($saveitem, $oLangStrings.menu.file.save)
	GUICtrlSetData($deleteitem, $oLangStrings.menu.file.delete)
	GUICtrlSetData($clearitem, $oLangStrings.menu.file.clear)
	GUICtrlSetData($createLinkItem, $oLangStrings.menu.file.shortcut)
	GUICtrlSetData($profilesOpenItem, $oLangStrings.menu.file.open)
	GUICtrlSetData($profilesImportItem, $oLangStrings.menu.file.import)
	GUICtrlSetData($profilesExportItem, $oLangStrings.menu.file.export)
	GUICtrlSetData($exititem, $oLangStrings.menu.file.Exit)

	GUICtrlSetData($viewmenu, $oLangStrings.menu.view.view)
	GUICtrlSetData($refreshitem, $oLangStrings.menu.view.refresh)
	GUICtrlSetData($send2trayitem, $oLangStrings.menu.view.tray)
	GUICtrlSetData($blacklistitem, $oLangStrings.menu.view.hide)

	GUICtrlSetData($toolsmenu, $oLangStrings.menu.tools.tools)
	GUICtrlSetData($pullitem, $oLangStrings.menu.tools.pull)

	GUICtrlSetData($disableitem, $oLangStrings.menu.tools.disable)
	GUICtrlSetData($releaseitem, $oLangStrings.menu.tools.release)
	GUICtrlSetData($renewitem, $oLangStrings.menu.tools.renew)
	GUICtrlSetData($cycleitem, $oLangStrings.menu.tools.cycle)
	GUICtrlSetData($settingsitem, $oLangStrings.menu.tools.settings)

	GUICtrlSetData($helpmenu, $oLangStrings.menu.help.help)
	GUICtrlSetData($helpitem, $oLangStrings.menu.help.docs)
	GUICtrlSetData($changelogitem, $oLangStrings.menu.help.changelog)
	GUICtrlSetData($checkUpdatesItem, $oLangStrings.menu.help.update)
	GUICtrlSetData($debugmenuitem, $oLangStrings.menu.help.debug)
	GUICtrlSetData($infoitem, $oLangStrings.menu.help.about)

	GUICtrlSetData($RestoreItem, $oLangStrings.traymenu.hide)
	GUICtrlSetData($aboutitem, $oLangStrings.traymenu.about)
	GUICtrlSetData($exititem, $oLangStrings.traymenu.exit)

	GUICtrlSetData($lvcon_rename, $oLangStrings.lvmenu.rename)
	GUICtrlSetData($lvcon_delete, $oLangStrings.lvmenu.delete)
	GUICtrlSetData($lvcon_arrAz, $oLangStrings.lvmenu.sortAsc)
	GUICtrlSetData($lvcon_arrZa, $oLangStrings.lvmenu.sortDesc)
	GUICtrlSetData($lvcreateLinkItem, $oLangStrings.lvmenu.shortcut)

	_GUICtrlToolbar_SetButtonText($hToolbar, $tb_apply, $oLangStrings.toolbar.apply)
	_GUICtrlToolbar_SetButtonText($hToolbar, $tb_refresh, $oLangStrings.toolbar.refresh)
	_GUICtrlToolbar_SetButtonText($hToolbar, $tb_add, $oLangStrings.toolbar.new)
	_GUICtrlToolbar_SetButtonText($hToolbar, $tb_save, $oLangStrings.toolbar.save)
	_GUICtrlToolbar_SetButtonText($hToolbar, $tb_delete, $oLangStrings.toolbar.delete)
	_GUICtrlToolbar_SetButtonText($hToolbar, $tb_clear, $oLangStrings.toolbar.clear)
EndFunc   ;==>_updateLang

Func _setLangEnglish()
	$oLangStrings.menu.file.file = "&File"
	$oLangStrings.menu.file.apply = "&Apply profile" & @TAB & "Enter"
	$oLangStrings.menu.file.rename = "&Rename" & @TAB & "F2"
	$oLangStrings.menu.file.new = "&New" & @TAB & "Ctrl+n"
	$oLangStrings.menu.file.save = "&Save" & @TAB & "Ctrl+s"
	$oLangStrings.menu.file.delete = "&Delete" & @TAB & "Del"
	$oLangStrings.menu.file.clear = "&Clear entries" & @TAB & "Ctrl+c"
	$oLangStrings.menu.file.shortcut = "Create s&hortcut to profile"
	$oLangStrings.menu.file.open = "Open File"
	$oLangStrings.menu.file.import = "Import profiles"
	$oLangStrings.menu.file.export = "Export profiles"
	$oLangStrings.menu.file.exit = "&Exit" & @TAB & "Esc"

	$oLangStrings.menu.view.view = "&View"
	$oLangStrings.menu.view.refresh = "&Refresh" & @TAB & "Ctrl+r"
	$oLangStrings.menu.view.tray = "Send to &tray" & @TAB & "Ctrl+t"
	$oLangStrings.menu.view.hide = "Hide adapters"

	$oLangStrings.menu.tools.tools = "&Tools"
	$oLangStrings.menu.tools.pull = "&Pull from adapter" & @TAB & "Ctrl+p"
	$oLangStrings.menu.tools.disable = "Disable adapter"
	$oLangStrings.menu.tools.enable = "Enable adapter"
	$oLangStrings.menu.tools.release = "&Release DHCP"
	$oLangStrings.menu.tools.renew = "Re&new DHCP"
	$oLangStrings.menu.tools.cycle = "Release/renew &cycle"
	$oLangStrings.menu.tools.settings = "&Settings"

	$oLangStrings.menu.help.help = "&Help"
	$oLangStrings.menu.help.docs = "&Online Documentation" & @TAB & "F1"
	$oLangStrings.menu.help.changelog = "Show &Change Log"
	$oLangStrings.menu.help.update = "Check for &Updates..."
	$oLangStrings.menu.help.debug = "&Debug Information"
	$oLangStrings.menu.help.about = "&About Simple IP Config"

	$oLangStrings.traymenu.hide = "Hide"
	$oLangStrings.traymenu.restore = "Restore"
	$oLangStrings.traymenu.about = "About"
	$oLangStrings.traymenu.exit = "Exit"

	$oLangStrings.lvmenu.rename = "Rename"
	$oLangStrings.lvmenu.delete = "Delete"
	$oLangStrings.lvmenu.sortAsc = "Sort A->Z"
	$oLangStrings.lvmenu.sortDesc = "Sort Z->A"
	$oLangStrings.lvmenu.shortcut = "Create shortcut to profile"

	$oLangStrings.toolbar.apply = "Apply"
	$oLangStrings.toolbar.refresh = "Refresh"
	$oLangStrings.toolbar.new = "New"
	$oLangStrings.toolbar.save = "Save"
	$oLangStrings.toolbar.delete = "Delete"
	$oLangStrings.toolbar.clear = "Clear"

	$oLangStrings.toolbar.apply_tip = "Apply"
	$oLangStrings.toolbar.refresh_tip = "Refresh"
	$oLangStrings.toolbar.new_tip = "Create new profile"
	$oLangStrings.toolbar.save_tip = "Save profile"
	$oLangStrings.toolbar.delete_tip = "Delete profile"
	$oLangStrings.toolbar.clear_tip = "Clear entries"
	$oLangStrings.toolbar.settings_tip = "Settings"
	$oLangStrings.toolbar.tray_tip = "Send to tray"

	ConsoleWrite("set english" & @CRLF)
EndFunc   ;==>_setLangEN

; placeholder for IT language for testing
Func _setLangItalian()
	$oLangStrings.toolbar.apply = "test"
	ConsoleWrite("set italian" & @CRLF)
EndFunc   ;==>_setLangEN