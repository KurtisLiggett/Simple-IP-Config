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

Func _getLangsAvailable()
	Local $aFileList = _FileListToArray(@ScriptDir & "\lang", "lang-*.json", $FLTA_FILES)
	Local $aLangsRet[20]
	Local $hFile, $fileData, $jsonData
	If IsArray($aFileList) Then
		For $i = 1 To $aFileList[0]
			$hFile = FileOpen(@ScriptDir & "\lang\" & $aFileList[$i], $FO_READ)
			$fileData = FileRead($hFile)
			FileClose($hFile)
			$jsonData = Json_Decode($fileData)
			$aLangsRet[$i - 1] = Json_Get($jsonData, ".language-info.name") & "   (" & Json_Get($jsonData, ".language-info.code") & ")"
		Next
;~ 	Else
;~ 		$aLangsRet[0] = "English   (en-US)"
	EndIf

	Return $aLangsRet
EndFunc   ;==>_getLangsAvailable

Func _initLang()
	;create object for language strings
	$oLangStrings = _langStrings()

	$oLangStrings.OSLang = _getLangID(@OSLang)
EndFunc   ;==>_initLang

Func _langStrings()
	Local $oMain = _AutoItObject_Create()
	Local $oMenu = _AutoItObject_Create()
	Local $oMenuFile = _AutoItObject_Create()
	Local $oMenuView = _AutoItObject_Create()
	Local $oMenuTools = _AutoItObject_Create()
	Local $oMenuHelp = _AutoItObject_Create()
	Local $oTraymenu = _AutoItObject_Create()
	Local $oLvmenu = _AutoItObject_Create()
	Local $oToolbar = _AutoItObject_Create()
	Local $oInterface = _AutoItObject_Create()
	Local $oInterfaceProps = _AutoItObject_Create()
	Local $oSettings = _AutoItObject_Create()
	Local $oAbout = _AutoItObject_Create()
	Local $oUpdates = _AutoItObject_Create()
	Local $oChangelog = _AutoItObject_Create()
	Local $oBlacklist = _AutoItObject_Create()
	Local $oMessage = _AutoItObject_Create()
	Local $oDialog = _AutoItObject_Create()

	;main object
	_AutoItObject_AddProperty($oMain, "menu", $ELSCOPE_PUBLIC, $oMenu)
	_AutoItObject_AddProperty($oMain, "traymenu", $ELSCOPE_PUBLIC, $oTraymenu)
	_AutoItObject_AddProperty($oMain, "lvmenu", $ELSCOPE_PUBLIC, $oLvmenu)
	_AutoItObject_AddProperty($oMain, "toolbar", $ELSCOPE_PUBLIC, $oToolbar)
	_AutoItObject_AddProperty($oMain, "interface", $ELSCOPE_PUBLIC, $oInterface)
	_AutoItObject_AddProperty($oMain, "settings", $ELSCOPE_PUBLIC, $oSettings)
	_AutoItObject_AddProperty($oMain, "about", $ELSCOPE_PUBLIC, $oAbout)
	_AutoItObject_AddProperty($oMain, "updates", $ELSCOPE_PUBLIC, $oUpdates)
	_AutoItObject_AddProperty($oMain, "changelog", $ELSCOPE_PUBLIC, $oChangelog)
	_AutoItObject_AddProperty($oMain, "blacklist", $ELSCOPE_PUBLIC, $oBlacklist)
	_AutoItObject_AddProperty($oMain, "message", $ELSCOPE_PUBLIC, $oMessage)
	_AutoItObject_AddProperty($oMain, "dialog", $ELSCOPE_PUBLIC, $oDialog)
	_AutoItObject_AddProperty($oMain, "OSLang")
	_AutoItObject_AddProperty($oMain, "buttonOK")
	_AutoItObject_AddProperty($oMain, "buttonCancel")
	_AutoItObject_AddProperty($oMain, "buttonSave")

	;menu
	_AutoItObject_AddProperty($oMenu, "file", $ELSCOPE_PUBLIC, $oMenuFile)
	_AutoItObject_AddProperty($oMenu, "view", $ELSCOPE_PUBLIC, $oMenuView)
	_AutoItObject_AddProperty($oMenu, "tools", $ELSCOPE_PUBLIC, $oMenuTools)
	_AutoItObject_AddProperty($oMenu, "help", $ELSCOPE_PUBLIC, $oMenuHelp)

	;interface
	_AutoItObject_AddProperty($oInterface, "props", $ELSCOPE_PUBLIC, $oInterfaceProps)

	;add the items
	_AutoItObject_AddProperty($oMenuFile, "file")
	_AutoItObject_AddProperty($oMenuFile, "apply")
	_AutoItObject_AddProperty($oMenuFile, "applyKey")
	_AutoItObject_AddProperty($oMenuFile, "rename")
	_AutoItObject_AddProperty($oMenuFile, "renameKey")
	_AutoItObject_AddProperty($oMenuFile, "new")
	_AutoItObject_AddProperty($oMenuFile, "newKey")
	_AutoItObject_AddProperty($oMenuFile, "save")
	_AutoItObject_AddProperty($oMenuFile, "saveKey")
	_AutoItObject_AddProperty($oMenuFile, "delete")
	_AutoItObject_AddProperty($oMenuFile, "deleteKey")
	_AutoItObject_AddProperty($oMenuFile, "clear")
	_AutoItObject_AddProperty($oMenuFile, "clearKey")
	_AutoItObject_AddProperty($oMenuFile, "shortcut")
	_AutoItObject_AddProperty($oMenuFile, "open")
	_AutoItObject_AddProperty($oMenuFile, "import")
	_AutoItObject_AddProperty($oMenuFile, "export")
	_AutoItObject_AddProperty($oMenuFile, "exit")

	_AutoItObject_AddProperty($oMenuView, "view")
	_AutoItObject_AddProperty($oMenuView, "refresh")
	_AutoItObject_AddProperty($oMenuView, "refreshKey")
	_AutoItObject_AddProperty($oMenuView, "tray")
	_AutoItObject_AddProperty($oMenuView, "trayKey")
	_AutoItObject_AddProperty($oMenuView, "hide")
	_AutoItObject_AddProperty($oMenuView, "appearance")
	_AutoItObject_AddProperty($oMenuView, "light")
	_AutoItObject_AddProperty($oMenuView, "dark")
	_AutoItObject_AddProperty($oMenuView, "memo")

	_AutoItObject_AddProperty($oMenuTools, "tools")
	_AutoItObject_AddProperty($oMenuTools, "netConn")
	_AutoItObject_AddProperty($oMenuTools, "pull")
	_AutoItObject_AddProperty($oMenuTools, "pullKey")
	_AutoItObject_AddProperty($oMenuTools, "disable")
	_AutoItObject_AddProperty($oMenuTools, "enable")
	_AutoItObject_AddProperty($oMenuTools, "release")
	_AutoItObject_AddProperty($oMenuTools, "renew")
	_AutoItObject_AddProperty($oMenuTools, "cycle")
	_AutoItObject_AddProperty($oMenuTools, "openprofloc")
	_AutoItObject_AddProperty($oMenuTools, "settings")

	_AutoItObject_AddProperty($oMenuHelp, "help")
	_AutoItObject_AddProperty($oMenuHelp, "docs")
	_AutoItObject_AddProperty($oMenuHelp, "docsKey")
	_AutoItObject_AddProperty($oMenuHelp, "changelog")
	_AutoItObject_AddProperty($oMenuHelp, "update")
	_AutoItObject_AddProperty($oMenuHelp, "debug")
	_AutoItObject_AddProperty($oMenuHelp, "about")

	_AutoItObject_AddProperty($oTraymenu, "hide")
	_AutoItObject_AddProperty($oTraymenu, "restore")
	_AutoItObject_AddProperty($oTraymenu, "about")
	_AutoItObject_AddProperty($oTraymenu, "exit")

	_AutoItObject_AddProperty($oLvmenu, "rename")
	_AutoItObject_AddProperty($oLvmenu, "delete")
	_AutoItObject_AddProperty($oLvmenu, "sortAsc")
	_AutoItObject_AddProperty($oLvmenu, "sortDesc")
	_AutoItObject_AddProperty($oLvmenu, "shortcut")

	_AutoItObject_AddProperty($oToolbar, "apply")
	_AutoItObject_AddProperty($oToolbar, "refresh")
	_AutoItObject_AddProperty($oToolbar, "new")
	_AutoItObject_AddProperty($oToolbar, "save")
	_AutoItObject_AddProperty($oToolbar, "delete")
	_AutoItObject_AddProperty($oToolbar, "clear")

	_AutoItObject_AddProperty($oToolbar, "apply_tip")
	_AutoItObject_AddProperty($oToolbar, "refresh_tip")
	_AutoItObject_AddProperty($oToolbar, "new_tip")
	_AutoItObject_AddProperty($oToolbar, "save_tip")
	_AutoItObject_AddProperty($oToolbar, "delete_tip")
	_AutoItObject_AddProperty($oToolbar, "clear_tip")
	_AutoItObject_AddProperty($oToolbar, "settings_tip")
	_AutoItObject_AddProperty($oToolbar, "tray_tip")

	_AutoItObject_AddProperty($oInterface, "computername")
	_AutoItObject_AddProperty($oInterface, "domain")
	_AutoItObject_AddProperty($oInterface, "workgroup")

	_AutoItObject_AddProperty($oInterface, "adapterDesc")
	_AutoItObject_AddProperty($oInterface, "mac")

	_AutoItObject_AddProperty($oInterface, "select")
	_AutoItObject_AddProperty($oInterface, "profiles")
	_AutoItObject_AddProperty($oInterface, "profileprops")
	_AutoItObject_AddProperty($oInterface, "currentprops")

	_AutoItObject_AddProperty($oInterface, "restarting")

	_AutoItObject_AddProperty($oInterfaceProps, "ip")
	_AutoItObject_AddProperty($oInterfaceProps, "subnet")
	_AutoItObject_AddProperty($oInterfaceProps, "gateway")
	_AutoItObject_AddProperty($oInterfaceProps, "dnsPref")
	_AutoItObject_AddProperty($oInterfaceProps, "dnsAlt")
	_AutoItObject_AddProperty($oInterfaceProps, "dhcpServer")
	_AutoItObject_AddProperty($oInterfaceProps, "adapterState")
	_AutoItObject_AddProperty($oInterfaceProps, "adapterStateEnabled")
	_AutoItObject_AddProperty($oInterfaceProps, "adapterStateDisabled")
	_AutoItObject_AddProperty($oInterfaceProps, "adapterStateUnplugged")

	_AutoItObject_AddProperty($oInterfaceProps, "ipauto")
	_AutoItObject_AddProperty($oInterfaceProps, "ipmanual")
	_AutoItObject_AddProperty($oInterfaceProps, "dnsauto")
	_AutoItObject_AddProperty($oInterfaceProps, "dnsmanual")
	_AutoItObject_AddProperty($oInterfaceProps, "dnsreg")
	_AutoItObject_AddProperty($oInterfaceProps, "memo")

	_AutoItObject_AddProperty($oUpdates, "title")
	_AutoItObject_AddProperty($oUpdates, "thisVersion")
	_AutoItObject_AddProperty($oUpdates, "latestVersion")
	_AutoItObject_AddProperty($oUpdates, "newMessage")
	_AutoItObject_AddProperty($oUpdates, "latestMessage")

	_AutoItObject_AddProperty($oAbout, "title")
	_AutoItObject_AddProperty($oAbout, "version")
	_AutoItObject_AddProperty($oAbout, "date")
	_AutoItObject_AddProperty($oAbout, "dev")
	_AutoItObject_AddProperty($oAbout, "lic")
	_AutoItObject_AddProperty($oAbout, "desc")
	_AutoItObject_AddProperty($oAbout, "icons")

	_AutoItObject_AddProperty($oChangelog, "changelog")

	_AutoItObject_AddProperty($oBlacklist, "title")
	_AutoItObject_AddProperty($oBlacklist, "heading")

	_AutoItObject_AddProperty($oSettings, "title")
	_AutoItObject_AddProperty($oSettings, "lang")
	_AutoItObject_AddProperty($oSettings, "opt1")
	_AutoItObject_AddProperty($oSettings, "opt2")
	_AutoItObject_AddProperty($oSettings, "opt3")
	_AutoItObject_AddProperty($oSettings, "opt4")

	_AutoItObject_AddProperty($oMessage, "ready")
	_AutoItObject_AddProperty($oMessage, "timedout")
	_AutoItObject_AddProperty($oMessage, "couldNotSave")
	_AutoItObject_AddProperty($oMessage, "updatingList")
	_AutoItObject_AddProperty($oMessage, "selectAdapter")
	_AutoItObject_AddProperty($oMessage, "enterIP")
	_AutoItObject_AddProperty($oMessage, "enterSubnet")
	_AutoItObject_AddProperty($oMessage, "settingIP")
	_AutoItObject_AddProperty($oMessage, "settingDnsDhcp")
	_AutoItObject_AddProperty($oMessage, "settingDnsPref")
	_AutoItObject_AddProperty($oMessage, "settingDnsAlt")
	_AutoItObject_AddProperty($oMessage, "errorOccurred")
	_AutoItObject_AddProperty($oMessage, "profileNameExists")
	_AutoItObject_AddProperty($oMessage, "noProfileSel")
	_AutoItObject_AddProperty($oMessage, "profilesNotFound")
	_AutoItObject_AddProperty($oMessage, "errorReadingProf")
	_AutoItObject_AddProperty($oMessage, "adapterNotFound")
	_AutoItObject_AddProperty($oMessage, "error")
	_AutoItObject_AddProperty($oMessage, "warning")
	_AutoItObject_AddProperty($oMessage, "newItem")
	_AutoItObject_AddProperty($oMessage, "applying")
	_AutoItObject_AddProperty($oMessage, "errorRetrieving")
	_AutoItObject_AddProperty($oMessage, "commandTimeout")
	_AutoItObject_AddProperty($oMessage, "updateCheckError")
	_AutoItObject_AddProperty($oMessage, "checkConnect")
	_AutoItObject_AddProperty($oMessage, "errorCode")
	_AutoItObject_AddProperty($oMessage, "newVersion")
	_AutoItObject_AddProperty($oMessage, "currentVersion")
	_AutoItObject_AddProperty($oMessage, "yourVersion")
	_AutoItObject_AddProperty($oMessage, "latestVersion")
	_AutoItObject_AddProperty($oMessage, "loadedFile")
	_AutoItObject_AddProperty($oMessage, "doneImporting")
	_AutoItObject_AddProperty($oMessage, "fileSaved")

	_AutoItObject_AddProperty($oDialog, "selectFile")
	_AutoItObject_AddProperty($oDialog, "ini")

	Return $oMain
EndFunc   ;==>_langStrings

Func _setLangStrings($langCode = "en-US", $manualUpdate = False)
	Local $fileData
	Local $hFile = FileOpen(@ScriptDir & "\lang\lang-" & $langCode & ".json", $FO_READ)
	If $hFile = -1 Then
		$fileData = _getEnglish()
		If $langCode <> "en-US" Then
			MsgBox(1, "Error", "Error reading language file")
		EndIf
	Else
		If $hFile = -1 Then
			MsgBox(1, "Error", "Error reading language file")
		EndIf
		$fileData = FileRead($hFile)
		FileClose($hFile)
	EndIf
	Local $jsonData = Json_Decode($fileData)

	$oLangStrings.menu.file.file = Json_Get($jsonData, ".strings.menu.file.file")
	$oLangStrings.menu.file.apply = Json_Get($jsonData, ".strings.menu.file.apply")
	$oLangStrings.menu.file.applyKey = Json_Get($jsonData, ".strings.menu.file.applyKey")
	$oLangStrings.menu.file.rename = Json_Get($jsonData, ".strings.menu.file.rename")
	$oLangStrings.menu.file.renameKey = Json_Get($jsonData, ".strings.menu.file.renameKey")
	$oLangStrings.menu.file.new = Json_Get($jsonData, ".strings.menu.file.new")
	$oLangStrings.menu.file.newKey = Json_Get($jsonData, ".strings.menu.file.newKey")
	$oLangStrings.menu.file.save = Json_Get($jsonData, ".strings.menu.file.save")
	$oLangStrings.menu.file.saveKey = Json_Get($jsonData, ".strings.menu.file.saveKey")
	$oLangStrings.menu.file.delete = Json_Get($jsonData, ".strings.menu.file.delete")
	$oLangStrings.menu.file.deleteKey = Json_Get($jsonData, ".strings.menu.file.deleteKey")
	$oLangStrings.menu.file.clear = Json_Get($jsonData, ".strings.menu.file.clear")
	$oLangStrings.menu.file.clearKey = Json_Get($jsonData, ".strings.menu.file.clearKey")
	$oLangStrings.menu.file.shortcut = Json_Get($jsonData, ".strings.menu.file.shortcut")
	$oLangStrings.menu.file.open = Json_Get($jsonData, ".strings.menu.file.open")
	$oLangStrings.menu.file.import = Json_Get($jsonData, ".strings.menu.file.import")
	$oLangStrings.menu.file.export = Json_Get($jsonData, ".strings.menu.file.export")
	$oLangStrings.menu.file.Exit = Json_Get($jsonData, ".strings.menu.file.exit")

	$oLangStrings.menu.view.view = Json_Get($jsonData, ".strings.menu.view.view")
	$oLangStrings.menu.view.refresh = Json_Get($jsonData, ".strings.menu.view.refresh")
	$oLangStrings.menu.view.refreshKey = Json_Get($jsonData, ".strings.menu.view.refreshKey")
	$oLangStrings.menu.view.tray = Json_Get($jsonData, ".strings.menu.view.tray")
	$oLangStrings.menu.view.trayKey = Json_Get($jsonData, ".strings.menu.view.trayKey")
	$oLangStrings.menu.view.hide = Json_Get($jsonData, ".strings.menu.view.hide")
	$oLangStrings.menu.view.appearance = Json_Get($jsonData, ".strings.menu.view.appearance.appearance")
	$oLangStrings.menu.view.light = Json_Get($jsonData, ".strings.menu.view.appearance.light")
	$oLangStrings.menu.view.dark = Json_Get($jsonData, ".strings.menu.view.appearance.dark")
	$oLangStrings.menu.view.memo = Json_Get($jsonData, ".strings.menu.view.memo")

	$oLangStrings.menu.tools.tools = Json_Get($jsonData, ".strings.menu.tools.tools")
	$oLangStrings.menu.tools.netConn = Json_Get($jsonData, ".strings.menu.tools.netConn")
	$oLangStrings.menu.tools.pull = Json_Get($jsonData, ".strings.menu.tools.pull")
	$oLangStrings.menu.tools.pullKey = Json_Get($jsonData, ".strings.menu.tools.pullKey")
	$oLangStrings.menu.tools.disable = Json_Get($jsonData, ".strings.menu.tools.disable")
	$oLangStrings.menu.tools.enable = Json_Get($jsonData, ".strings.menu.tools.enable")
	$oLangStrings.menu.tools.release = Json_Get($jsonData, ".strings.menu.tools.release")
	$oLangStrings.menu.tools.renew = Json_Get($jsonData, ".strings.menu.tools.renew")
	$oLangStrings.menu.tools.cycle = Json_Get($jsonData, ".strings.menu.tools.cycle")
	$oLangStrings.menu.tools.openprofloc = Json_Get($jsonData, ".strings.menu.tools.openprofloc")
	$oLangStrings.menu.tools.settings = Json_Get($jsonData, ".strings.menu.tools.settings")

	$oLangStrings.menu.help.help = Json_Get($jsonData, ".strings.menu.help.help")
	$oLangStrings.menu.help.docs = Json_Get($jsonData, ".strings.menu.help.docs")
	$oLangStrings.menu.help.docsKey = Json_Get($jsonData, ".strings.menu.help.docsKey")
	$oLangStrings.menu.help.changelog = Json_Get($jsonData, ".strings.menu.help.changelog")
	$oLangStrings.menu.help.update = Json_Get($jsonData, ".strings.menu.help.update")
	$oLangStrings.menu.help.debug = Json_Get($jsonData, ".strings.menu.help.debug")
	$oLangStrings.menu.help.about = Json_Get($jsonData, ".strings.menu.help.about")

	$oLangStrings.traymenu.hide = Json_Get($jsonData, ".strings.traymenu.hide")
	$oLangStrings.traymenu.restore = Json_Get($jsonData, ".strings.traymenu.restore")
	$oLangStrings.traymenu.about = Json_Get($jsonData, ".strings.traymenu.about")
	$oLangStrings.traymenu.Exit = Json_Get($jsonData, ".strings.traymenu.exit")

	$oLangStrings.lvmenu.rename = Json_Get($jsonData, ".strings.lvmenu.rename")
	$oLangStrings.lvmenu.delete = Json_Get($jsonData, ".strings.lvmenu.delete")
	$oLangStrings.lvmenu.sortAsc = Json_Get($jsonData, ".strings.lvmenu.sortAsc")
	$oLangStrings.lvmenu.sortDesc = Json_Get($jsonData, ".strings.lvmenu.sortDesc")
	$oLangStrings.lvmenu.shortcut = Json_Get($jsonData, ".strings.lvmenu.shortcut")

	$oLangStrings.toolbar.apply = Json_Get($jsonData, ".strings.toolbar.apply")
	$oLangStrings.toolbar.refresh = Json_Get($jsonData, ".strings.toolbar.refresh")
	$oLangStrings.toolbar.new = Json_Get($jsonData, ".strings.toolbar.new")
	$oLangStrings.toolbar.save = Json_Get($jsonData, ".strings.toolbar.save")
	$oLangStrings.toolbar.delete = Json_Get($jsonData, ".strings.toolbar.delete")
	$oLangStrings.toolbar.clear = Json_Get($jsonData, ".strings.toolbar.clear")

	$oLangStrings.toolbar.apply_tip = Json_Get($jsonData, ".strings.toolbar.apply_tip")
	$oLangStrings.toolbar.refresh_tip = Json_Get($jsonData, ".strings.toolbar.refresh_tip")
	$oLangStrings.toolbar.new_tip = Json_Get($jsonData, ".strings.toolbar.new_tip")
	$oLangStrings.toolbar.save_tip = Json_Get($jsonData, ".strings.toolbar.save_tip")
	$oLangStrings.toolbar.delete_tip = Json_Get($jsonData, ".strings.toolbar.delete_tip")
	$oLangStrings.toolbar.clear_tip = Json_Get($jsonData, ".strings.toolbar.clear_tip")
	$oLangStrings.toolbar.settings_tip = Json_Get($jsonData, ".strings.toolbar.settings_tip")
	$oLangStrings.toolbar.tray_tip = Json_Get($jsonData, ".strings.toolbar.tray_tip")

	$oLangStrings.interface.computername = Json_Get($jsonData, ".strings.interface.computername")
	$oLangStrings.interface.domain = Json_Get($jsonData, ".strings.interface.domain")
	$oLangStrings.interface.workgroup = Json_Get($jsonData, ".strings.interface.workgroup")

	$oLangStrings.interface.props.ip = Json_Get($jsonData, ".strings.interface.props.ip")
	$oLangStrings.interface.props.subnet = Json_Get($jsonData, ".strings.interface.props.subnet")
	$oLangStrings.interface.props.gateway = Json_Get($jsonData, ".strings.interface.props.gateway")
	$oLangStrings.interface.props.dnsPref = Json_Get($jsonData, ".strings.interface.props.dnsPref")
	$oLangStrings.interface.props.dnsAlt = Json_Get($jsonData, ".strings.interface.props.dnsAlt")
	$oLangStrings.interface.props.dhcpServer = Json_Get($jsonData, ".strings.interface.props.dhcpServer")
	$oLangStrings.interface.props.adapterState = Json_Get($jsonData, ".strings.interface.props.adapterState")
	$oLangStrings.interface.props.adapterStateEnabled = Json_Get($jsonData, ".strings.interface.props.adapterStateEnabled")
	$oLangStrings.interface.props.adapterStateDisabled = Json_Get($jsonData, ".strings.interface.props.adapterStateDisabled")
	$oLangStrings.interface.props.adapterStateUnplugged = Json_Get($jsonData, ".strings.interface.props.adapterStateUnplugged")
	$oLangStrings.interface.props.memo = Json_Get($jsonData, ".strings.interface.props.memo")

	$oLangStrings.interface.props.ipauto = Json_Get($jsonData, ".strings.interface.props.ipauto")
	$oLangStrings.interface.props.ipmanual = Json_Get($jsonData, ".strings.interface.props.ipmanual")
	$oLangStrings.interface.props.dnsauto = Json_Get($jsonData, ".strings.interface.props.dnsauto")
	$oLangStrings.interface.props.dnsmanual = Json_Get($jsonData, ".strings.interface.props.dnsmanual")
	$oLangStrings.interface.props.dnsreg = Json_Get($jsonData, ".strings.interface.props.dnsreg")

	$oLangStrings.interface.adapterDesc = Json_Get($jsonData, ".strings.interface.adapterDesc")
	$oLangStrings.interface.mac = Json_Get($jsonData, ".strings.interface.mac")

	$oLangStrings.interface.Select = Json_Get($jsonData, ".strings.interface.select")
	$oLangStrings.interface.profiles = Json_Get($jsonData, ".strings.interface.profiles")
	$oLangStrings.interface.profileprops = Json_Get($jsonData, ".strings.interface.profileprops")
	$oLangStrings.interface.currentprops = Json_Get($jsonData, ".strings.interface.currentprops")

	$oLangStrings.interface.restarting = Json_Get($jsonData, ".strings.interface.restarting")

	$oLangStrings.updates.title = Json_Get($jsonData, ".strings.updates.title")
	$oLangStrings.updates.thisVersion = Json_Get($jsonData, ".strings.updates.thisVersion")
	$oLangStrings.updates.latestVersion = Json_Get($jsonData, ".strings.updates.latestVersion")
	$oLangStrings.updates.newMessage = Json_Get($jsonData, ".strings.updates.newMessage")
	$oLangStrings.updates.latestMessage = Json_Get($jsonData, ".strings.updates.latestMessage")

	$oLangStrings.about.title = Json_Get($jsonData, ".strings.about.title")
	$oLangStrings.about.version = Json_Get($jsonData, ".strings.about.version")
	$oLangStrings.about.date = Json_Get($jsonData, ".strings.about.date")
	$oLangStrings.about.dev = Json_Get($jsonData, ".strings.about.dev")
	$oLangStrings.about.lic = Json_Get($jsonData, ".strings.about.lic")
	$oLangStrings.about.desc = Json_Get($jsonData, ".strings.about.desc")
	$oLangStrings.about.icons = Json_Get($jsonData, ".strings.about.icons")

	$oLangStrings.changelog.changelog = Json_Get($jsonData, ".strings.changelog.changelog")

	$oLangStrings.blacklist.title = Json_Get($jsonData, ".strings.blacklist.title")
	$oLangStrings.blacklist.heading = Json_Get($jsonData, ".strings.blacklist.heading")

	$oLangStrings.settings.title = Json_Get($jsonData, ".strings.settings.title")
	$oLangStrings.settings.lang = Json_Get($jsonData, ".strings.settings.lang")
	$oLangStrings.settings.opt1 = Json_Get($jsonData, ".strings.settings.opt1")
	$oLangStrings.settings.opt2 = Json_Get($jsonData, ".strings.settings.opt2")
	$oLangStrings.settings.opt3 = Json_Get($jsonData, ".strings.settings.opt3")
	$oLangStrings.settings.opt4 = Json_Get($jsonData, ".strings.settings.opt4")

	$oLangStrings.buttonOK = Json_Get($jsonData, ".strings.buttonOK")
	$oLangStrings.buttonCancel = Json_Get($jsonData, ".strings.buttonCancel")
	$oLangStrings.buttonSave = Json_Get($jsonData, ".strings.buttonSave")

	$oLangStrings.message.ready = Json_Get($jsonData, ".strings.message.ready")
	$oLangStrings.message.timedout = Json_Get($jsonData, ".strings.message.timedout")
	$oLangStrings.message.couldNotSave = Json_Get($jsonData, ".strings.message.couldNotSave")
	$oLangStrings.message.updatingList = Json_Get($jsonData, ".strings.message.updatingList")
	$oLangStrings.message.selectAdapter = Json_Get($jsonData, ".strings.message.selectAdapter")
	$oLangStrings.message.enterIP = Json_Get($jsonData, ".strings.message.enterIP")
	$oLangStrings.message.enterSubnet = Json_Get($jsonData, ".strings.message.enterSubnet")
	$oLangStrings.message.settingIP = Json_Get($jsonData, ".strings.message.settingIP	")
	$oLangStrings.message.settingDnsDhcp = Json_Get($jsonData, ".strings.message.settingDnsDhcp")
	$oLangStrings.message.settingDnsPref = Json_Get($jsonData, ".strings.message.settingDnsPref")
	$oLangStrings.message.settingDnsAlt = Json_Get($jsonData, ".strings.message.settingDnsAlt")
	$oLangStrings.message.errorOccurred = Json_Get($jsonData, ".strings.message.errorOccurred")
	$oLangStrings.message.profileNameExists = Json_Get($jsonData, ".strings.message.profileNameExists")
	$oLangStrings.message.noProfileSel = Json_Get($jsonData, ".strings.message.noProfileSel")
	$oLangStrings.message.profilesNotFound = Json_Get($jsonData, ".strings.message.profilesNotFound")
	$oLangStrings.message.errorReadingProf = Json_Get($jsonData, ".strings.message.errorReadingProf")
	$oLangStrings.message.adapterNotFound = Json_Get($jsonData, ".strings.message.adapterNotFound")
	$oLangStrings.message.error = Json_Get($jsonData, ".strings.message.error")
	$oLangStrings.message.warning = Json_Get($jsonData, ".strings.message.warning")
	$oLangStrings.message.newItem = Json_Get($jsonData, ".strings.message.newItem")
	$oLangStrings.message.applying = Json_Get($jsonData, ".strings.message.applying")
	$oLangStrings.message.errorRetrieving = Json_Get($jsonData, ".strings.message.errorRetrieving")
	$oLangStrings.message.commandTimeout = Json_Get($jsonData, ".strings.message.commandTimeout")
	$oLangStrings.message.updateCheckError = Json_Get($jsonData, ".strings.message.updateCheckError")
	$oLangStrings.message.checkConnect = Json_Get($jsonData, ".strings.message.checkConnect")
	$oLangStrings.message.errorCode = Json_Get($jsonData, ".strings.message.errorCode")
	$oLangStrings.message.newVersion = Json_Get($jsonData, ".strings.message.newVersion")
	$oLangStrings.message.currentVersion = Json_Get($jsonData, ".strings.message.currentVersion")
	$oLangStrings.message.yourVersion = Json_Get($jsonData, ".strings.message.yourVersion")
	$oLangStrings.message.latestVersion = Json_Get($jsonData, ".strings.message.latestVersion")
	$oLangStrings.message.loadedFile = Json_Get($jsonData, ".strings.message.loadedFile")
	$oLangStrings.message.doneImporting = Json_Get($jsonData, ".strings.message.doneImporting")
	$oLangStrings.message.fileSaved = Json_Get($jsonData, ".strings.message.fileSaved")

	$oLangStrings.dialog.selectFile = Json_Get($jsonData, ".strings.dialog.selectFile")
	$oLangStrings.dialog.ini = Json_Get($jsonData, ".strings.dialog.ini")
EndFunc   ;==>_setLangStrings

Func _getEnglish()
	Return '' & _
			'{' & _
			'   "language-info":{' & _
			'      "name":"English",' & _
			'      "code":"en-US"' & _
			'   },' & _
			'   "strings":{' & _
			'      "buttonOK":"OK",' & _
			'      "buttonCancel":"Cancel",' & _
			'      "buttonSave":"Save",' & _
			'      "menu":{' & _
			'         "file":{' & _
			'            "file":"&File",' & _
			'            "apply":"&Apply profile",' & _
			'            "applyKey":"Enter",' & _
			'            "rename":"&Rename",' & _
			'            "renameKey":"F2",' & _
			'            "new":"&New",' & _
			'            "newKey":"Ctrl+n",' & _
			'            "save":"&Save",' & _
			'            "saveKey":"Ctrl+s",' & _
			'            "delete":"&Delete",' & _
			'            "deleteKey":"Del",' & _
			'            "clear":"&Clear entries",' & _
			'            "clearKey":"Ctrl+c",' & _
			'            "shortcut":"Create shortcut to profile",' & _
			'            "open":"Open File",' & _
			'            "import":"Import profiles",' & _
			'            "export":"Export profiles",' & _
			'            "exit":"&Exit"' & _
			'         },' & _
			'         "view":{' & _
			'            "view":"&View",' & _
			'            "refresh":"&Refresh",' & _
			'            "refreshKey":"Ctrl+r",' & _
			'            "tray":"Send to &tray",' & _
			'            "trayKey":"Ctrl+t",' & _
			'            "hide":"Hide adapters",' & _
			'            "appearance":{' & _
			'            	"appearance":"Appearance",' & _
			'            	"light":"Light",' & _
			'            	"dark":"Dark"' & _
			'            },' & _
			'            "memo":"Show memo"' & _
			'         },' & _
			'         "tools":{' & _
			'            "tools":"&Tools",' & _
			'            "netConn":"Open Network Connections",' & _
			'            "pull":"&Pull from adapter",' & _
			'            "pullKey":"Ctrl+p",' & _
			'            "disable":"Disable adapter",' & _
			'            "enable":"Enable adapter",' & _
			'            "release":"&Release DHCP",' & _
			'            "renew":"Re&new DHCP",' & _
			'            "cycle":"Release/renew &cycle",' & _
			'            "openprofloc":"Go to profiles.ini folder",' & _
			'            "settings":"&Settings"' & _
			'         },' & _
			'         "help":{' & _
			'            "help":"&Help",' & _
			'            "docs":"&Online Documentation",' & _
			'            "docsKey":"F1",' & _
			'            "changelog":"Show &Change Log",' & _
			'            "update":"Check for &Updates...",' & _
			'            "debug":"&Debug Information",' & _
			'            "about":"&About Simple IP Config"' & _
			'         }' & _
			'      },' & _
			'      "traymenu":{' & _
			'         "hide":"Hide",' & _
			'         "restore":"Restore",' & _
			'         "about":"About",' & _
			'         "exit":"Exit"' & _
			'      },' & _
			'      "lvmenu":{' & _
			'         "rename":"Rename",' & _
			'         "delete":"Delete",' & _
			'         "sortAsc":"Sort A->Z",' & _
			'         "sortDesc":"Sort Z->A",' & _
			'         "shortcut":"Create shortcut to profile"' & _
			'      },' & _
			'      "toolbar":{' & _
			'         "apply":"Apply",' & _
			'         "refresh":"Refresh",' & _
			'         "new":"New",' & _
			'         "save":"Save",' & _
			'         "delete":"Delete",' & _
			'         "clear":"Clear",' & _
			'         "apply_tip":"Apply",' & _
			'         "refresh_tip":"Refresh",' & _
			'         "new_tip":"Create new profile",' & _
			'         "save_tip":"Save profile",' & _
			'         "delete_tip":"Delete profile",' & _
			'         "clear_tip":"Clear entries",' & _
			'         "settings_tip":"Settings",' & _
			'         "tray_tip":"Send to tray"' & _
			'      },' & _
			'      "interface":{' & _
			'         "computername":"Computer name",' & _
			'         "domain":"Domain",' & _
			'         "workgroup":"Workgroup",' & _
			'         "adapterDesc":"Description",' & _
			'         "mac":"MAC Address",' & _
			'         "select":"Select Adapter",' & _
			'         "profiles":"Profiles",' & _
			'         "profileprops":"Profile IP Properties",' & _
			'         "currentprops":"Current Adapter Properties",' & _
			'         "props":{' & _
			'            "ip":"IP Address",' & _
			'            "subnet":"Subnet Mask",' & _
			'            "gateway":"Gateway",' & _
			'            "dnsPref":"Preferred DNS Server",' & _
			'            "dnsAlt":"Alternate DNS Server",' & _
			'            "dhcpServer":"DHCP Server",' & _
			'            "adapterState":"Adapter State",' & _
			'            "adapterStateEnabled":"Enabled",' & _
			'            "adapterStateDisabled":"Disabled",' & _
			'            "adapterStateUnplugged":"Unplugged",' & _
			'            "ipauto":"Automatically Set IP Address",' & _
			'            "ipmanual":"Manually Set IP Address",' & _
			'            "dnsauto":"Automatically Set DNS Address",' & _
			'            "dnsmanual":"Manually Set DNS Address",' & _
			'            "dnsreg":"Register Addresses",' & _
			'            "memo":"Memo"' & _
			'         }' & _
			'      },' & _
			'      "updates":{' & _
			'         "title":"Check for Updates",' & _
			'         "thisVersion":"This Version",' & _
			'         "latestVersion":"Latest Version",' & _
			'         "newMessage":"A newer version is available.",' & _
			'         "latestMessage":"You have the latest version."' & _
			'      },' & _
			'      "about":{' & _
			'         "title":"About",' & _
			'         "version":"Version",' & _
			'         "date":"Date",' & _
			'         "dev":"Developer",' & _
			'         "lic":"License",' & _
			'         "desc":"The portable ip changer utility that allows a user to quickly and easily change the most common network settings for any connection.",' & _
			'         "icons":"Program icons are from"' & _
			'      },' & _
			'      "changelog":{' & _
			'         "changelog":"Change Log"' & _
			'      },' & _
			'      "blacklist":{' & _
			'         "title":"Adapter Blacklist",' & _
			'         "heading":"Select Adapters to Hide"' & _
			'      },' & _
			'      "settings":{' & _
			'         "title":"Settings",' & _
			'         "lang":"Language",' & _
			'         "opt1":"Startup in system tray",' & _
			'         "opt2":"Close to the system tray",' & _
			'         "opt3":"Save adapter to profile",' & _
			'         "opt4":"Automatically check for updates"' & _
			'      },' & _
			'      "message":{' & _
			'         "ready":"Ready",' & _
			'         "timedout":"Action timed out!  Command Aborted.",' & _
			'         "couldNotSave":"Could not save to the selected location!",' & _
			'         "updatingList":"Updating Adapter List...",' & _
			'         "selectAdapter":"Select an adapter and try again",' & _
			'         "enterIP":"Enter an IP address",' & _
			'         "enterSubnet":"Enter a subnet mask",' & _
			'         "settingIP":"Setting static IP address...",' & _
			'         "settingDnsDhcp":"Setting DNS DHCP...",' & _
			'         "settingDnsPref":"Setting preferred DNS server...",' & _
			'         "settingDnsAlt":"Setting alternate DNS server...",' & _
			'         "errorOccurred":"An error occurred",' & _
			'         "profileNameExists":"The profile name already exists!",' & _
			'         "noProfileSel":"No profile is selected!",' & _
			'         "profilesNotFound":"Profiles.ini file not found - A new file will be created",' & _
			'         "errorReadingProf":"Error reading profiles.ini",' & _
			'         "adapterNotFound":"Adapter not found",' & _
			'         "error":"Error",' & _
			'         "warning":"Warning",' & _
			'         "newItem":"New Item",' & _
			'         "applying":"Applying profile",' & _
			'         "errorRetrieving":"There was a problem retrieving the adapters.",' & _
			'         "commandTimeout":"Command timeout",' & _
			'         "updateCheckError":"An error was encountered while retrieving the update.",' & _
			'         "checkConnect":"Please check your internet connection.",' & _
			'         "errorCode":"Error code",' & _
			'         "newVersion":"A newer version is available",' & _
			'         "currentVersion":"You have the latest version.",' & _
			'         "yourVersion":"Your version is",' & _
			'         "latestVersion":"Latest version is",' & _
			'         "loadedFile":"Loaded file",' & _
			'         "doneImporting":"Done importing profiles",' & _
			'         "fileSaved":"File saved"' & _
			'      },' & _
			'      "dialog":{' & _
			'         "selectFile":"Select File",' & _
			'         "ini":"INI Files"' & _
			'      }' & _
			'   }' & _
			'}'
EndFunc   ;==>_getEnglish

Func _getLangID($code)
	Local $langID

	;format OS language
	Switch $code
		Case "0004"
			$langID = "zh-CHS"
		Case "0401"
			$langID = "ar-SA"
		Case "0402"
			$langID = "bg-BG"
		Case "0403"
			$langID = "ca-ES"
		Case "0404"
			$langID = "zh-TW"
		Case "0405"
			$langID = "cs-CZ"
		Case "0406"
			$langID = "da-DK"
		Case "0407"
			$langID = "de-DE"
		Case "0408"
			$langID = "el-GR"
		Case "0409"
			$langID = "en-US"
		Case "040A"
			$langID = "es-ES_tradnl"
		Case "040B"
			$langID = "fi-FI"
		Case "040C"
			$langID = "fr-FR"
		Case "040D"
			$langID = "he-IL"
		Case "040E"
			$langID = "hu-HU"
		Case "040F"
			$langID = "is-IS"
		Case "0410"
			$langID = "it-IT"
		Case "0411"
			$langID = "ja-JP"
		Case "0412"
			$langID = "ko-KR"
		Case "0413"
			$langID = "nl-NL"
		Case "0414"
			$langID = "nb-NO"
		Case "0415"
			$langID = "pl-PL"
		Case "0416"
			$langID = "pt-BR"
		Case "0417"
			$langID = "rm-CH"
		Case "0418"
			$langID = "ro-RO"
		Case "0419"
			$langID = "ru-RU"
		Case "041A"
			$langID = "hr-HR"
		Case "041B"
			$langID = "sk-SK"
		Case "041C"
			$langID = "sq-AL"
		Case "041D"
			$langID = "sv-SE"
		Case "041E"
			$langID = "th-TH"
		Case "041F"
			$langID = "tr-TR"
		Case "0420"
			$langID = "ur-PK"
		Case "0421"
			$langID = "id-ID"
		Case "0422"
			$langID = "uk-UA"
		Case "0423"
			$langID = "be-BY"
		Case "0424"
			$langID = "sl-SI"
		Case "0425"
			$langID = "et-EE"
		Case "0426"
			$langID = "lv-LV"
		Case "0427"
			$langID = "lt-LT"
		Case "0428"
			$langID = "tg-Cyrl-TJ"
		Case "0429"
			$langID = "fa-IR"
		Case "042A"
			$langID = "vi-VN"
		Case "042B"
			$langID = "hy-AM"
		Case "042C"
			$langID = "az-Latn-AZ"
		Case "042D"
			$langID = "eu-ES"
		Case "042E"
			$langID = "hsb-DE"
		Case "042F"
			$langID = "mk-MK"
		Case "0432"
			$langID = "tn-ZA"
		Case "0434"
			$langID = "xh-ZA"
		Case "0435"
			$langID = "zu-ZA"
		Case "0436"
			$langID = "af-ZA"
		Case "0437"
			$langID = "ka-GE"
		Case "0438"
			$langID = "fo-FO"
		Case "0439"
			$langID = "hi-IN"
		Case "043A"
			$langID = "mt-MT"
		Case "043B"
			$langID = "se-NO"
		Case "043e"
			$langID = "ms-MY"
		Case "043F"
			$langID = "kk-KZ"
		Case "0440"
			$langID = "ky-KG"
		Case "0441"
			$langID = "sw-KE"
		Case "0442"
			$langID = "tk-TM"
		Case "0443"
			$langID = "uz-Latn-UZ"
		Case "0444"
			$langID = "tt-RU"
		Case "0445"
			$langID = "bn-IN"
		Case "0446"
			$langID = "pa-IN"
		Case "0447"
			$langID = "gu-IN"
		Case "0448"
			$langID = "or-IN"
		Case "0449"
			$langID = "ta-IN"
		Case "044A"
			$langID = "te-IN"
		Case "044B"
			$langID = "kn-IN"
		Case "044C"
			$langID = "ml-IN"
		Case "044D"
			$langID = "as-IN"
		Case "044E"
			$langID = "mr-IN"
		Case "044F"
			$langID = "sa-IN"
		Case "0450"
			$langID = "mn-MN"
		Case "0451"
			$langID = "bo-CN"
		Case "0452"
			$langID = "cy-GB"
		Case "0453"
			$langID = "km-KH"
		Case "0454"
			$langID = "lo-LA"
		Case "0456"
			$langID = "gl-ES"
		Case "0457"
			$langID = "kok-IN"
		Case "0459"
			$langID = "sd-Deva-IN"
		Case "045A"
			$langID = "syr-SY"
		Case "045B"
			$langID = "si-LK"
		Case "045C"
			$langID = "chr-Cher-US"
		Case "045D"
			$langID = "iu-Cans-CA"
		Case "045E"
			$langID = "am-ET"
		Case "0461"
			$langID = "ne-NP"
		Case "0462"
			$langID = "fy-NL"
		Case "0463"
			$langID = "ps-AF"
		Case "0464"
			$langID = "fil-PH"
		Case "0465"
			$langID = "dv-MV"
		Case "0468"
			$langID = "ha-Latn-NG"
		Case "046A"
			$langID = "yo-NG"
		Case "046B"
			$langID = "quz-BO"
		Case "046C"
			$langID = "nso-ZA"
		Case "046D"
			$langID = "ba-RU"
		Case "046E"
			$langID = "lb-LU"
		Case "046F"
			$langID = "kl-GL"
		Case "0470"
			$langID = "ig-NG"
		Case "0473"
			$langID = "ti-ET"
		Case "0475"
			$langID = "haw-US"
		Case "0478"
			$langID = "ii-CN"
		Case "047A"
			$langID = "arn-CL"
		Case "047C"
			$langID = "moh-CA"
		Case "047E"
			$langID = "br-FR"
		Case "0480"
			$langID = "ug-CN"
		Case "0481"
			$langID = "mi-NZ"
		Case "0482"
			$langID = "oc-FR"
		Case "0483"
			$langID = "co-FR"
		Case "0484"
			$langID = "gsw-FR"
		Case "0485"
			$langID = "sah-RU"
		Case "0486"
			$langID = "quc-Latn-GT"
		Case "0487"
			$langID = "rw-RW"
		Case "0488"
			$langID = "wo-SN"
		Case "048C"
			$langID = "prs-AF"
		Case "0491"
			$langID = "gd-GB"
		Case "0492"
			$langID = "ku-Arab-IQ"
		Case "0801"
			$langID = "ar-IQ"
		Case "0803"
			$langID = "ca-ES-valencia"
		Case "0804"
			$langID = "zh-CN"
		Case "0807"
			$langID = "de-CH"
		Case "0809"
			$langID = "en-GB"
		Case "080A"
			$langID = "es-MX"
		Case "080C"
			$langID = "fr-BE"
		Case "0810"
			$langID = "it-CH"
		Case "0813"
			$langID = "nl-BE"
		Case "0814"
			$langID = "nn-NO"
		Case "0816"
			$langID = "pt-PT"
		Case "081A"
			$langID = "sr-Latn-CS"
		Case "081D"
			$langID = "sv-FI"
		Case "0820"
			$langID = "ur-IN"
		Case "082C"
			$langID = "az-Cyrl-AZ"
		Case "082E"
			$langID = "dsb-DE"
		Case "0832"
			$langID = "tn-BW"
		Case "083B"
			$langID = "se-SE"
		Case "083C"
			$langID = "ga-IE"
		Case "083E"
			$langID = "ms-BN"
		Case "0843"
			$langID = "uz-Cyrl-UZ"
		Case "0845"
			$langID = "bn-BD"
		Case "0846"
			$langID = "pa-Arab-PK"
		Case "0849"
			$langID = "ta-LK"
		Case "0850"
			$langID = "mn-Mong-CN"
		Case "0859"
			$langID = "sd-Arab-PK"
		Case "085D"
			$langID = "iu-Latn-CA"
		Case "085F"
			$langID = "tzm-Latn-DZ"
		Case "0867"
			$langID = "ff-Latn-SN"
		Case "086B"
			$langID = "quz-EC"
		Case "0873"
			$langID = "ti-ER"
		Case "0873"
			$langID = "ti-ER"
		Case "0C01"
			$langID = "ar-EG"
		Case "0C04"
			$langID = "zh-HK"
		Case "0C07"
			$langID = "de-AT"
		Case "0C09"
			$langID = "en-AU"
		Case "0C0A"
			$langID = "es-ES"
		Case "0C0C"
			$langID = "fr-CA"
		Case "0C1A"
			$langID = "sr-Cyrl-CS"
		Case "0C3B"
			$langID = "se-FI"
		Case "0C6B"
			$langID = "quz-PE"
		Case "1001"
			$langID = "ar-LY"
		Case "1004"
			$langID = "zh-SG"
		Case "1007"
			$langID = "de-LU"
		Case "1009"
			$langID = "en-CA"
		Case "100A"
			$langID = "es-GT"
		Case "100C"
			$langID = "fr-CH"
		Case "101A"
			$langID = "hr-BA"
		Case "103B"
			$langID = "smj-NO"
		Case "105F"
			$langID = "tzm-Tfng-MA"
		Case "1401"
			$langID = "ar-DZ"
		Case "1404"
			$langID = "zh-MO"
		Case "1407"
			$langID = "de-LI"
		Case "1409"
			$langID = "en-NZ"
		Case "140A"
			$langID = "es-CR"
		Case "140C"
			$langID = "fr-LU"
		Case "141A"
			$langID = "bs-Latn-BA"
		Case "143B"
			$langID = "smj-SE"
		Case "1801"
			$langID = "ar-MA"
		Case "1809"
			$langID = "en-IE"
		Case "180A"
			$langID = "es-PA"
		Case "180C"
			$langID = "fr-MC"
		Case "181A"
			$langID = "sr-Latn-BA"
		Case "183B"
			$langID = "sma-NO"
		Case "1C01"
			$langID = "ar-TN"
		Case "1c09"
			$langID = "en-ZA"
		Case "1C0A"
			$langID = "es-DO"
		Case "1C1A"
			$langID = "sr-Cyrl-BA"
		Case "1C3B"
			$langID = "sma-SE"
		Case "2001"
			$langID = "ar-OM"
		Case "2009"
			$langID = "en-JM"
		Case "200A"
			$langID = "es-VE"
		Case "201A"
			$langID = "bs-Cyrl-BA"
		Case "203B"
			$langID = "sms-FI"
		Case "2401"
			$langID = "ar-YE"
		Case "2409"
			$langID = "en-029"
		Case "240A"
			$langID = "es-CO"
		Case "241A"
			$langID = "sr-Latn-RS"
		Case "243B"
			$langID = "smn-FI"
		Case "2801"
			$langID = "ar-SY"
		Case "2809"
			$langID = "en-BZ"
		Case "280A"
			$langID = "es-PE"
		Case "281A"
			$langID = "sr-Cyrl-RS"
		Case "2C01"
			$langID = "ar-JO"
		Case "2C09"
			$langID = "en-TT"
		Case "2C0A"
			$langID = "es-AR"
		Case "2C1A"
			$langID = "sr-Latn-ME"
		Case "3001"
			$langID = "ar-LB"
		Case "3009"
			$langID = "en-ZW"
		Case "300A"
			$langID = "es-EC"
		Case "301A"
			$langID = "sr-Cyrl-ME"
		Case "3401"
			$langID = "ar-KW"
		Case "3409"
			$langID = "en-PH"
		Case "340A"
			$langID = "es-CL"
		Case "3801"
			$langID = "ar-AE"
		Case "380A"
			$langID = "es-UY"
		Case "3C01"
			$langID = "ar-BH"
		Case "3C0A"
			$langID = "es-PY"
		Case "4001"
			$langID = "ar-QA"
		Case "4009"
			$langID = "en-IN"
		Case "400A"
			$langID = "es-BO"
		Case "4409"
			$langID = "en-MY"
		Case "440A"
			$langID = "es-SV"
		Case "4809"
			$langID = "en-SG"
		Case "480A"
			$langID = "es-HN"
		Case "4C0A"
			$langID = "es-NI"
		Case "500A"
			$langID = "es-PR"
		Case "540A"
			$langID = "es-US"
		Case "7C04"
			$langID = "zh-CHT"
		Case Else
			$langID = "en-US"
	EndSwitch

	Return $langID
EndFunc   ;==>_getLangID
