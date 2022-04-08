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
	$oLangStrings.lvmenu = IDispatch()    ;listview menu
	$oLangStrings.toolbar = IDispatch()
	$oLangStrings.interface = IDispatch()
	$oLangStrings.interface.props = IDispatch()
	$oLangStrings.settings = IDispatch()
	$oLangStrings.about = IDispatch()
	$oLangStrings.updates = IDispatch()
	$oLangStrings.changelog = IDispatch()
	$oLangStrings.blacklist = IDispatch()
	$oLangStrings.message = IDispatch()
	$oLangStrings.dialog = IDispatch()

	;format OS language
	Switch @OSLang
		Case "0409"
			$oLangStrings.OSLang = "en-US"
		Case "0410"
			$oLangStrings.OSLang = "it-IT"
		Case "0419"
			$oLangStrings.OSLang = "ru-RU"
		Case Else
			$oLangStrings.OSLang = "en-US"
	EndSwitch
EndFunc   ;==>_initLang

;~ Func _getLangStringID($sLang)
;~ 	Local $retVal = -1
;~ 	Switch $sLang
;~ 		Case "English"
;~ 			$retVal = "en-US"
;~ 		Case "Italiano"
;~ 			$retVal = "it-IT"
;~ 		Case "русский"
;~ 			$retVal = "ru-RU"
;~ 		Case Else
;~ 			$retVal = -1
;~ 	EndSwitch
;~ 	Return $retVal
;~ EndFunc   ;==>_getLangStringID

;~ func _setLangStrings($manualUpdate = False)
;~ 	_setLang($oLangStrings.OSLang)

;~ 	Switch $oLangStrings.OSLang
;~ 		Case "en-US"
;~ 			_setLangEnglish()
;~ 		Case "it-IT"
;~ 			_setLangItalian()
;~ 		Case Else
;~ 			_setLangEnglish()
;~ 	EndSwitch

;~ 	If $manualUpdate Then _updateLang()
;~ EndFunc

Func _getLangsAvailable()
	Local $aFileList = _FileListToArray(@ScriptDir, "lang-*.json", $FLTA_FILES)
	Local $aLangsRet[20]
	Local $hFile, $fileData, $jsonData
	For $i = 1 To $aFileList[0]
		$hFile = FileOpen($aFileList[$i], $FO_READ)
		$fileData = FileRead($hFile)
		FileClose($hFile)
		$jsonData = Json_Decode($fileData)
		$aLangsRet[$i - 1] = Json_Get($jsonData, ".language-info.name") & "   (" & Json_Get($jsonData, ".language-info.code") & ")"
	Next

	Return $aLangsRet
EndFunc   ;==>_getLangsAvailable

Func _setLangStrings($langCode = "en-US", $manualUpdate = False)
	Local $fileData
	Local $hFile = FileOpen("lang-" & $langCode & ".json", $FO_READ)
	If $hFile = -1 Then
		If $langCode = "en-US" Then
			$fileData = _getEnglish()
		Else
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
	$oLangStrings.menu.file.exit = Json_Get($jsonData, ".strings.menu.file.exit")

	$oLangStrings.menu.view.view = Json_Get($jsonData, ".strings.menu.view.view")
	$oLangStrings.menu.view.refresh = Json_Get($jsonData, ".strings.menu.view.refresh")
	$oLangStrings.menu.view.refreshKey = Json_Get($jsonData, ".strings.menu.view.refreshKey")
	$oLangStrings.menu.view.tray = Json_Get($jsonData, ".strings.menu.view.tray")
	$oLangStrings.menu.view.trayKey = Json_Get($jsonData, ".strings.menu.view.trayKey")
	$oLangStrings.menu.view.hide = Json_Get($jsonData, ".strings.menu.view.hide")

	$oLangStrings.menu.tools.tools = Json_Get($jsonData, ".strings.menu.tools.tools")
	$oLangStrings.menu.tools.netConn = Json_Get($jsonData, ".strings.menu.tools.netConn")
	$oLangStrings.menu.tools.pull = Json_Get($jsonData, ".strings.menu.tools.pull")
	$oLangStrings.menu.tools.pullKey = Json_Get($jsonData, ".strings.menu.tools.pullKey")
	$oLangStrings.menu.tools.disable = Json_Get($jsonData, ".strings.menu.tools.disable")
	$oLangStrings.menu.tools.enable = Json_Get($jsonData, ".strings.menu.tools.enable")
	$oLangStrings.menu.tools.release = Json_Get($jsonData, ".strings.menu.tools.release")
	$oLangStrings.menu.tools.renew = Json_Get($jsonData, ".strings.menu.tools.renew")
	$oLangStrings.menu.tools.cycle = Json_Get($jsonData, ".strings.menu.tools.cycle")
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
	$oLangStrings.traymenu.exit = Json_Get($jsonData, ".strings.traymenu.exit")

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

	$oLangStrings.interface.props.ipauto = Json_Get($jsonData, ".strings.interface.props.ipauto")
	$oLangStrings.interface.props.ipmanual = Json_Get($jsonData, ".strings.interface.props.ipmanual")
	$oLangStrings.interface.props.dnsauto = Json_Get($jsonData, ".strings.interface.props.dnsauto")
	$oLangStrings.interface.props.dnsmanual = Json_Get($jsonData, ".strings.interface.props.dnsmanual")
	$oLangStrings.interface.props.dnsreg = Json_Get($jsonData, ".strings.interface.props.dnsreg")

	$oLangStrings.interface.adapterDesc = Json_Get($jsonData, ".strings.interface.adapterDesc")
	$oLangStrings.interface.mac = Json_Get($jsonData, ".strings.interface.mac")

	$oLangStrings.interface.select = Json_Get($jsonData, ".strings.interface.select")
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
	$oLangStrings.message.enterIP = "Enter an IP address"
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

	If $manualUpdate Then _updateLang()
EndFunc   ;==>_setLangStrings

Func _updateLang()
	GUICtrlSetData($filemenu, $oLangStrings.menu.file.file)
	GUICtrlSetData($applyitem, $oLangStrings.menu.file.apply & @TAB & $oLangStrings.menu.file.applyKey)
	GUICtrlSetData($renameitem, $oLangStrings.menu.file.rename & @TAB & $oLangStrings.menu.file.renameKey)
	GUICtrlSetData($newitem, $oLangStrings.menu.file.new & @TAB & $oLangStrings.menu.file.newKey)
	GUICtrlSetData($saveitem, $oLangStrings.menu.file.save & @TAB & $oLangStrings.menu.file.saveKey)
	GUICtrlSetData($deleteitem, $oLangStrings.menu.file.delete & @TAB & $oLangStrings.menu.file.deleteKey)
	GUICtrlSetData($clearitem, $oLangStrings.menu.file.clear & @TAB & $oLangStrings.menu.file.clearKey)
	GUICtrlSetData($createLinkItem, $oLangStrings.menu.file.shortcut)
	GUICtrlSetData($profilesOpenItem, $oLangStrings.menu.file.open)
	GUICtrlSetData($profilesImportItem, $oLangStrings.menu.file.import)
	GUICtrlSetData($profilesExportItem, $oLangStrings.menu.file.export)
	GUICtrlSetData($exititem, $oLangStrings.menu.file.exit)

	GUICtrlSetData($viewmenu, $oLangStrings.menu.view.view)
	GUICtrlSetData($refreshitem, $oLangStrings.menu.view.refresh & @TAB & $oLangStrings.menu.view.refreshKey)
	GUICtrlSetData($send2trayitem, $oLangStrings.menu.view.tray & @TAB & $oLangStrings.menu.view.trayKey)
	GUICtrlSetData($blacklistitem, $oLangStrings.menu.view.hide)

	GUICtrlSetData($toolsmenu, $oLangStrings.menu.tools.tools)
	GUICtrlSetData($netConnItem, $oLangStrings.menu.tools.netConn)
	GUICtrlSetData($pullitem, $oLangStrings.menu.tools.pull & @TAB & $oLangStrings.menu.tools.pullKey)
	GUICtrlSetData($disableitem, $oLangStrings.menu.tools.disable)
	GUICtrlSetData($releaseitem, $oLangStrings.menu.tools.release)
	GUICtrlSetData($renewitem, $oLangStrings.menu.tools.renew)
	GUICtrlSetData($cycleitem, $oLangStrings.menu.tools.cycle)
	GUICtrlSetData($settingsitem, $oLangStrings.menu.tools.settings)

	GUICtrlSetData($helpmenu, $oLangStrings.menu.help.help)
	GUICtrlSetData($helpitem, $oLangStrings.menu.help.docs & @TAB & $oLangStrings.menu.help.docsKey)
	GUICtrlSetData($changelogitem, $oLangStrings.menu.help.changelog)
	GUICtrlSetData($checkUpdatesItem, $oLangStrings.menu.help.update)
	GUICtrlSetData($debugmenuitem, $oLangStrings.menu.help.debug)
	GUICtrlSetData($infoitem, $oLangStrings.menu.help.about)

	GUICtrlSetData($RestoreItem, $oLangStrings.traymenu.hide)
	GUICtrlSetData($aboutitem, $oLangStrings.traymenu.about)
	GUICtrlSetData($exititemtray, $oLangStrings.traymenu.exit)

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

	GUICtrlSetData($computerName, $oLangStrings.interface.computername & ": " & @ComputerName)
	GUICtrlSetData($domainName, _DomainComputerBelongs())

	GUICtrlSetData($label_CurrIp, $oLangStrings.interface.props.ip & ":")
	GUICtrlSetData($label_CurrSubnet, $oLangStrings.interface.props.subnet & ":")
	GUICtrlSetData($label_CurrGateway, $oLangStrings.interface.props.gateway & ":")
	GUICtrlSetData($label_CurrDnsPri, $oLangStrings.interface.props.dnsPref & ":")
	GUICtrlSetData($label_CurrDnsAlt, $oLangStrings.interface.props.dnsAlt & ":")
	GUICtrlSetData($label_CurrDhcp, $oLangStrings.interface.props.dhcpServer & ":")
	GUICtrlSetData($label_CurrAdapterState, $oLangStrings.interface.props.adapterState & ":")
	GUICtrlSetData($label_CurrentAdapterState, "")

	GUICtrlSetData($radio_IpAuto, $oLangStrings.interface.props.ipauto)
	GUICtrlSetData($radio_IpMan, $oLangStrings.interface.props.ipmanual)
	GUICtrlSetData($radio_DnsAuto, $oLangStrings.interface.props.dnsauto)
	GUICtrlSetData($radio_DnsMan, $oLangStrings.interface.props.dnsmanual)

	GUICtrlSetData($label_ip, $oLangStrings.interface.props.ip & ":")
	GUICtrlSetData($label_subnet, $oLangStrings.interface.props.subnet & ":")
	GUICtrlSetData($label_gateway, $oLangStrings.interface.props.gateway & ":")
	GUICtrlSetData($label_DnsPri, $oLangStrings.interface.props.dnsPref & ":")
	GUICtrlSetData($label_DnsAlt, $oLangStrings.interface.props.dnsAlt & ":")
	GUICtrlSetData($ck_dnsReg, $oLangStrings.interface.props.dnsreg)

	GUICtrlSetData($lDescription, $oLangStrings.interface.adapterDesc)
	GUICtrlSetData($lMac, $oLangStrings.interface.mac & ": ")

	GUICtrlSetData($headingSelect, $oLangStrings.interface.select)
	GUICtrlSetData($headingProfiles, $oLangStrings.interface.profiles)
	GUICtrlSetData($headingIP, $oLangStrings.interface.profileprops)
	GUICtrlSetData($headingCurrent, $oLangStrings.interface.currentprops)
EndFunc   ;==>_updateLang

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
			'            "hide":"Hide adapters"' & _
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
			'            "dnsreg":"Register Addresses"' & _
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
			'         "opt2":"Minimize to the system tray",' & _
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
