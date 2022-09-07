#Region license
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
#EndRegion license

;==============================================================================
; Filename:		gui.au3
; Description:	- GUI creation and related functions
;==============================================================================


Func _form_main()
	; =================================================
	#Region main-gui
	; GUI FORMATTING
	Local $ixCoordMin = _WinAPI_GetSystemMetrics(76)
	Local $iyCoordMin = _WinAPI_GetSystemMetrics(77)
	Local $iFullDesktopWidth = _WinAPI_GetSystemMetrics(78)
	Local $iFullDesktopHeight = _WinAPI_GetSystemMetrics(79)
	Local $sPositionX = $options.PositionX
	If $sPositionX <> "" Then
		$xpos = $sPositionX
		If $xpos > ($ixCoordMin + $iFullDesktopWidth) Then
			$xpos = $iFullDesktopWidth - ($guiWidth * $dscale)
		ElseIf $xpos < $ixCoordMin Then
			$xpos = 1
		EndIf
	Else
		$xpos = @DesktopWidth / 2 - $guiWidth * $dscale / 2
	EndIf
	Local $sPositionY = $options.PositionY
	If $sPositionY <> "" Then
		$ypos = $sPositionY
		If $ypos > ($iyCoordMin + $iFullDesktopHeight) Then
			$ypos = $iFullDesktopHeight - ($guiHeight * $dscale)
		ElseIf $ypos < $iyCoordMin Then
			$ypos = 1
		EndIf
	Else
		$ypos = @DesktopHeight / 2 - $guiHeight * $dscale / 2
	EndIf

	; ---- create the main GUI
	$hgui = GUICreate($winName & " " & $winVersion, $guiWidth * $dscale, $guiHeight * $dscale, $xpos, $ypos, BitOR($GUI_SS_DEFAULT_GUI, $WS_CLIPCHILDREN), $WS_EX_COMPOSITED)
;~ 	GUISetBkColor(0xFFFFFF)
	GUISetBkColor(0x1a81d7)

	; GUI SET EVENTS
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExit")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "_minimize")
	GUISetOnEvent($GUI_EVENT_RESTORE, "_maximize")
	GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "_clickDn")
	GUISetOnEvent($GUI_EVENT_PRIMARYUP, "_clickUp")

	GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
	GUIRegisterMsg($WM_NOTIFY, 'WM_NOTIFY')

	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)
	_GDIPlus_Startup()

	$strSize = _StringSize("{", $MyGlobalFontSize, 400, 0, $MyGlobalFontName)
	$MyGlobalFontHeight = $strSize[1]

	;create line under main menu
	GUICtrlCreateLabel("", 0, 0, $guiWidth, 1)
	GUICtrlSetBkColor(-1, 0x888888)
	GUICtrlSetState(-1, $GUI_DISABLE)
	#EndRegion main-gui


	; =================================================
	#Region main-menu
	$filemenu = GUICtrlCreateMenu($oLangStrings.menu.file.file)
	$applyitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.apply & @TAB & $oLangStrings.menu.file.applyKey, $filemenu)
	GUICtrlSetOnEvent(-1, "_onApply")
	GUICtrlCreateMenuItem("", $filemenu)
	$renameitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.rename & @TAB & $oLangStrings.menu.file.renameKey, $filemenu)
	GUICtrlSetOnEvent(-1, "_onRename")
	$newitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.new & @TAB & $oLangStrings.menu.file.newKey, $filemenu)
	GUICtrlSetOnEvent(-1, "_onNewItem")
	$saveitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.save & @TAB & $oLangStrings.menu.file.saveKey, $filemenu)
	GUICtrlSetOnEvent(-1, "_onSave")
	$deleteitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.delete & @TAB & $oLangStrings.menu.file.deleteKey, $filemenu)
	GUICtrlSetOnEvent(-1, "_onDelete")
	$clearitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.clear, $filemenu)
	GUICtrlSetOnEvent(-1, "_onClear")
	$createLinkItem = GUICtrlCreateMenuItem($oLangStrings.menu.file.shortcut, $filemenu)
	GUICtrlSetOnEvent(-1, "_onCreateLink")
	GUICtrlCreateMenuItem("", $filemenu)     ; create a separator line
	$profilesOpenItem = GUICtrlCreateMenuItem($oLangStrings.menu.file.open, $filemenu)
	GUICtrlSetOnEvent(-1, "_onOpenProfiles")
	$profilesImportItem = GUICtrlCreateMenuItem($oLangStrings.menu.file.import, $filemenu)
	GUICtrlSetOnEvent(-1, "_onImportProfiles")
	$profilesExportItem = GUICtrlCreateMenuItem($oLangStrings.menu.file.export, $filemenu)
	GUICtrlSetOnEvent(-1, "_onExportProfiles")
	GUICtrlCreateMenuItem("", $filemenu)
	$exititem = GUICtrlCreateMenuItem($oLangStrings.menu.file.Exit, $filemenu)
	GUICtrlSetOnEvent(-1, "_onExit")

	$viewmenu = GUICtrlCreateMenu($oLangStrings.menu.view.view)
	$refreshitem = GUICtrlCreateMenuItem($oLangStrings.menu.view.refresh & @TAB & $oLangStrings.menu.view.refreshKey, $viewmenu)
	GUICtrlSetOnEvent(-1, "_onRefresh")
	$send2trayitem = GUICtrlCreateMenuItem($oLangStrings.menu.view.tray & @TAB & $oLangStrings.menu.view.trayKey, $viewmenu)
	GUICtrlSetOnEvent(-1, "_onTray")
	GUICtrlCreateMenuItem("", $viewmenu)     ; create a separator line
	$blacklistitem = GUICtrlCreateMenuItem($oLangStrings.menu.view.hide, $viewmenu)
	GUICtrlSetOnEvent(-1, "_onBlacklist")

	$toolsmenu = GUICtrlCreateMenu($oLangStrings.menu.tools.tools)
	$netConnItem = GUICtrlCreateMenuItem($oLangStrings.menu.tools.netConn, $toolsmenu)
	GUICtrlSetOnEvent(-1, "_onOpenNetConnections")
	$pullitem = GUICtrlCreateMenuItem($oLangStrings.menu.tools.pull & @TAB & $oLangStrings.menu.tools.pullKey, $toolsmenu)
	GUICtrlSetOnEvent(-1, "_onPull")
	$disableitem = GUICtrlCreateMenuItem($oLangStrings.menu.tools.disable, $toolsmenu)
	GUICtrlSetOnEvent(-1, "_onDisable")
	GUICtrlCreateMenuItem("", $toolsmenu)
	$releaseitem = GUICtrlCreateMenuItem($oLangStrings.menu.tools.release, $toolsmenu)
	GUICtrlSetOnEvent(-1, "_onRelease")
	$renewitem = GUICtrlCreateMenuItem($oLangStrings.menu.tools.renew, $toolsmenu)
	GUICtrlSetOnEvent(-1, "_onRenew")
	$cycleitem = GUICtrlCreateMenuItem($oLangStrings.menu.tools.cycle, $toolsmenu)
	GUICtrlSetOnEvent(-1, "_onCycle")
	GUICtrlCreateMenuItem("", $toolsmenu)
	Local $openProfLocItem = GUICtrlCreateMenuItem($oLangStrings.menu.tools.openprofloc, $toolsmenu)
	GUICtrlSetOnEvent(-1, "_onOpenProfLoc")
	$settingsitem = GUICtrlCreateMenuItem($oLangStrings.menu.tools.settings, $toolsmenu)
	GUICtrlSetOnEvent(-1, "_onSettings")

	$helpmenu = GUICtrlCreateMenu($oLangStrings.menu.help.help)
	$helpitem = GUICtrlCreateMenuItem($oLangStrings.menu.help.docs & @TAB & $oLangStrings.menu.help.docsKey, $helpmenu)
	GUICtrlSetOnEvent(-1, "_onHelp")
	GUICtrlCreateMenuItem("", $helpmenu)
	$changelogitem = GUICtrlCreateMenuItem($oLangStrings.menu.help.changelog, $helpmenu)
	GUICtrlSetOnEvent(-1, "_onChangelog")
	$checkUpdatesItem = GUICtrlCreateMenuItem($oLangStrings.menu.help.update, $helpmenu)
	GUICtrlSetOnEvent(-1, "_onUpdateCheckItem")
	$debugmenuitem = GUICtrlCreateMenuItem($oLangStrings.menu.help.debug, $helpmenu)
	GUICtrlSetOnEvent(-1, "_onDebugItem")
	$infoitem = GUICtrlCreateMenuItem($oLangStrings.menu.help.about, $helpmenu)
	GUICtrlSetOnEvent(-1, "_onAbout")

	;$Lclientsize = WinGetClientSize( $hGUI )
	$menuHeight = _WinAPI_GetSystemMetrics($SM_CYMENU)
	;$menuHeight = $guiheight - $Lclientsize[1]
	$LCaptionBorder = WinGetPos($hgui)
	;$captionHeight = $LCaptionBorder[3] - $guiheight
	$captionHeight = _WinAPI_GetSystemMetrics($SM_CYSIZE)
	#EndRegion main-menu


	; =================================================
	#Region tray-menu
	$RestoreItem = TrayCreateItem($oLangStrings.traymenu.hide)
	TrayItemSetOnEvent(-1, "_OnRestore")
	$aboutitem = TrayCreateItem($oLangStrings.traymenu.about)
	TrayItemSetOnEvent(-1, "_onAbout")
	TrayCreateItem("")
	$exititemtray = TrayCreateItem($oLangStrings.traymenu.Exit)
	TrayItemSetOnEvent(-1, "_onExit")
	TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, "_OnTrayClick")
	TraySetToolTip($winName)
	#EndRegion tray-menu


	; =================================================
	#Region toolbar
;~ 	Local $aColorsEx = _
;~ 			[0x666666, 0xFCFCFC, 0x666666, _ ; normal 	: Background, Text, Border
;~ 			0x666666, 0xFCFCFC, 0x666666, _     ; focus 	: Background, Text, Border
;~ 			0x888888, 0xFCFCFC, 0x999999, _     ; hover 	: Background, Text, Border
;~ 			0x555555, 0xFCFCFC, 0x444444]     ; selected 	: Background, Text, Border

;~ 	;create horizontal toolbar and add buttons
;~ 	$oToolbar = _GuiFlatToolbarCreate(-1, 4, 4, 52 * $dscale, $tbarHeight * $dscale - 8, $aColorsEx)
;~ 	_GuiFlatToolbar_SetBkColor($oToolbar, 0x666666)
;~ 	;add new buttons and associate an icon
;~ 	$tbButtonApply = _GuiFlatToolbar_AddButton($oToolbar, $oLangStrings.toolbar.apply, _getMemoryAsIcon(GetIconData($pngAccept)))
;~ 	GUICtrlSetTip(-1, $oLangStrings.toolbar.apply_tip)
;~ 	GUICtrlSetOnEvent(-1, "_apply_GUI")
;~ 	_GuiFlatToolbar_AddButton($oToolbar, $oLangStrings.toolbar.refresh, _getMemoryAsIcon(GetIconData($pngRefresh)))
;~ 	GUICtrlSetTip(-1, $oLangStrings.toolbar.refresh_tip)
;~ 	GUICtrlSetOnEvent(-1, "_onRefresh")
;~ 	_GuiFlatToolbar_AddButton($oToolbar, $oLangStrings.toolbar.new, _getMemoryAsIcon(GetIconData($pngAdd)))
;~ 	GUICtrlSetTip(-1, $oLangStrings.toolbar.new_tip)
;~ 	GUICtrlSetOnEvent(-1, "_onNewItem")
;~ 	_GuiFlatToolbar_AddButton($oToolbar, $oLangStrings.toolbar.save, _getMemoryAsIcon(GetIconData($pngSave)))
;~ 	GUICtrlSetTip(-1, $oLangStrings.toolbar.save_tip)
;~ 	GUICtrlSetOnEvent(-1, "_onSave")
;~ 	_GuiFlatToolbar_AddButton($oToolbar, $oLangStrings.toolbar.delete, _getMemoryAsIcon(GetIconData($pngDelete)))
;~ 	GUICtrlSetTip(-1, $oLangStrings.toolbar.delete_tip)
;~ 	GUICtrlSetOnEvent(-1, "_onDelete")
;~ 	_GuiFlatToolbar_AddButton($oToolbar, $oLangStrings.toolbar.clear, _getMemoryAsIcon(GetIconData($pngEdit)))
;~ 	GUICtrlSetTip(-1, $oLangStrings.toolbar.clear_tip)
;~ 	GUICtrlSetOnEvent(-1, "_onClear")

;~ 	_GuiFlatToolbar_SetAutoWidth($oToolbar)

;~ 	;create vertical toolbar and add buttons
;~ 	$oToolbar2 = _GuiFlatToolbarCreate(BitOR($GFTB_VERTICAL, $GFTB_RIGHT), 4, 4, 22 * $dscale, 22 * $dscale, $aColorsEx)
;~ 	_GuiFlatToolbar_SetBkColor($oToolbar2, 0x666666)
;~ 	;add new buttons and associate an icon
;~ 	_GuiFlatToolbar_AddButton($oToolbar2, "", _getMemoryAsIcon(GetIconData($pngSettings)))
;~ 	GUICtrlSetTip(-1, $oLangStrings.toolbar.settings_tip)
;~ 	GUICtrlSetOnEvent(-1, "_onSettings")
;~ 	_GuiFlatToolbar_AddButton($oToolbar2, "", _getMemoryAsIcon(GetIconData($pngTray)))
;~ 	GUICtrlSetTip(-1, $oLangStrings.toolbar.tray_tip)
;~ 	GUICtrlSetOnEvent(-1, "_onTray")
	#EndRegion toolbar


	; =================================================
	#Region statusbar
	$y = $guiHeight * $dscale - $statusbarHeight * $dscale - $menuHeight
	$x = 0
	$w = $guiWidth * $dscale
	$h = $statusbarHeight * $dscale

	$wgraphic = GUICtrlCreatePic("", $w - 20, $y + 2 * $dscale, 16, 16)
	_memoryToPic($wgraphic, GetIconData($pngWarning))
	GUICtrlSetOnEvent(-1, "_statusPopup")
	GUICtrlSetState($wgraphic, $GUI_HIDE)
	GUICtrlSetCursor($wgraphic, 0)

	$statustext = GUICtrlCreateLabel($oLangStrings.message.ready, $x + 3, $y + 3, $w - 2, $h - 2)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	$statuserror = GUICtrlCreateLabel("", $x + 3, $y + 3, $w - 2, $h - 2)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetOnEvent(-1, "_statusPopup")
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetState($statuserror, $GUI_HIDE)

	GUICtrlCreateLabel("", $x, $y + 1, $w, 1)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel("", $x, $y, $w, 1)
	GUICtrlSetBkColor(-1, 0x404040)

	GUICtrlCreateLabel("", $x, $y, $w, $h)
	GUICtrlSetBkColor(-1, _WinAPI_GetSysColor($COLOR_MENUBAR))
	#EndRegion statusbar


	; =================================================
	#Region footer
	$x = 0
	$y = $guiheight * $dscale - $statusbarHeight * $dscale - $footerHeight * $dscale - $menuHeight
	$w = $guiWidth * $dscale
	$h = $footerHeight * $dscale

;~ 	GUICtrlCreateLabel("", $x, $y, $w, 1)
;~ 	GUICtrlSetBkColor(-1, 0x404040)

	If $screenshot Then
		$computerName = GUICtrlCreateLabel($oLangStrings.interface.computername & ": ________", $x + 3, $y + 2, $w / 2, $h)
	Else
		$computerName = GUICtrlCreateLabel($oLangStrings.interface.computername & ": " & @ComputerName, $x + 3, $y + 2, $w / 2, $h)
	EndIf
	GUICtrlSetBkColor($computerName, 0x1a81d7)
	_setFont($computerName, 8, -1, 0xFFFFFF)

	If @LogonDomain <> "" Then
		$domainName = GUICtrlCreateLabel("", $w / 2, $y + 2, $w / 2 - 3, $h, $SS_RIGHT)
		GUICtrlSetBkColor($domainName, 0x1a81d7)
		_setFont($domainName, 8, -1, 0xFFFFFF)
	EndIf
	#EndRegion footer


	Local $guiSpacer = 0
	Local $y_offset = 0
	Local $y = $tbarHeight * $dscale + $guiSpacer + $y_offset + 2
	Local $xLeft = $guiSpacer
	Local $wLeft = 200 * $dscale
	Local $xRight = $xLeft + $wLeft + 2 * $dscale
	Local $wRight = $guiWidth * $dscale - $wLeft - 2 * $guiSpacer - 3 * $dscale - 2 * $dscale
	Local $hLeft = $tbarHeight * $dscale + $guiSpacer + $y_offset


	; =================================================
	#Region profile-buttons
	Local $menuColor = _WinAPI_GetSysColor($COLOR_MENUBAR)
	Local $hoverColor = $menuColor * 0.9
	Local $buttonSpace = 0 * $dscale
	Local $aColorsEx = _
			[$menuColor, 0xFCFCFC, $menuColor, _     ; normal 	: Background, Text, Border
			$menuColor, 0xFCFCFC, $menuColor, _     ; focus 	: Background, Text, Border
			$hoverColor, 0xFCFCFC, $hoverColor, _      ; hover 	: Background, Text, Border
			$menuColor, 0xFCFCFC, $menuColor]        ; selected 	: Background, Text, Border

	Local $thisButton = GuiFlatButton_Create("", 2, $y, 22 * $dscale, 22 * $dscale, $BS_TOOLBUTTON)
	GUICtrlSetTip(-1, $oLangStrings.toolbar.new_tip)
	GUICtrlSetOnEvent(-1, "_onNewItem")
	GuiFlatButton_SetColorsEx($thisButton, $aColorsEx)
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($thisButton), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($pngNew16))))

	$thisButton = GuiFlatButton_Create("", 2 + 22 * $dscale + $buttonSpace, $y, 22 * $dscale, 22 * $dscale, $BS_TOOLBUTTON)
	GUICtrlSetTip(-1, $oLangStrings.toolbar.save_tip)
	GUICtrlSetOnEvent(-1, "_onSave")
	GuiFlatButton_SetColorsEx($thisButton, $aColorsEx)
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($thisButton), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($pngSave16))))

	GUICtrlCreateLabel("", 2 + 22 * $dscale * 2 + 3 * $dscale, $y, 1, 22 * $dscale)
	GUICtrlSetBkColor(-1, 0xBBBBBB)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$thisButton = GuiFlatButton_Create("", 2 + 22 * $dscale * 2 + 6 * $dscale, $y, 22 * $dscale, 22 * $dscale, $BS_TOOLBUTTON)
	GUICtrlSetTip(-1, $oLangStrings.toolbar.delete_tip)
	GUICtrlSetOnEvent(-1, "_onDelete")
	GuiFlatButton_SetColorsEx($thisButton, $aColorsEx)
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($thisButton), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($pngDelete16))))

	;right line
	GUICtrlCreateLabel("", $wLeft - 1, $y - 1, 1, 22 * $dscale + 2)
	GUICtrlSetBkColor(-1, 0x888888)
	GUICtrlSetState(-1, $GUI_DISABLE)

	;bottom line
	GUICtrlCreateLabel("", 0, 22 * $dscale + 2, $wLeft - 1, 1)
	GUICtrlSetBkColor(-1, 0xAAAAAA)
	GUICtrlSetState(-1, $GUI_DISABLE)

	;background
	GUICtrlCreateLabel("", 0, $y - 1, $wLeft - 1, 22 * $dscale + 2)
	GUICtrlSetBkColor(-1, $menuColor)
	GUICtrlSetState(-1, $GUI_DISABLE)
	#EndRegion profile-buttons


	; ================================================
	#Region profiles-list
	$y_offset = 22 * $dscale + 3
	$x = $xLeft
	$y = $tbarHeight * $dscale + $guiSpacer + $y_offset
	$w = $wLeft
	$h = $guiHeight * $dscale - $hLeft - $menuHeight - $statusbarHeight * $dscale - $guiSpacer - $footerHeight * $dscale + 1 * $dscale - $y_offset
	$searchgraphic = GUICtrlCreatePic("", $x + 5, $y + 3 + 2 * $dscale, 16, 16)
	;_ResourceSetImageToCtrl($hGUI, $searchgraphic, "search_png")
	_memoryToPic($searchgraphic, GetIconData($pngSearch))

	$input_filter = GUICtrlCreateInput("*", $x + 12 + 11, $y + 3 + 2 * $dscale, $w - 12 - 18, 15 * $dscale, -1, $WS_EX_TOOLWINDOW)
	GUICtrlCreateLabel("", $x + 3, $y + 3, $w - 6, 20 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlCreateLabel("", $x + 2, $y + 2, $w - 4, 20 * $dscale + 2)
	GUICtrlSetBkColor(-1, 0x777777)
	$filter_dummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent($filter_dummy, "_onFilter")

	$list_profiles = GUICtrlCreateListView($oLangStrings.interface.profiles, $x + 1, $y + 2 + 20 * $dscale + 3, $w - 2, $h - 3 - 20 * $dscale - 3 - 1, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOCOLUMNHEADER, $LVS_EDITLABELS), $WS_EX_TRANSPARENT)
	_GUICtrlListView_SetColumnWidth($list_profiles, 0, $w - 2 - 20 * $dscale)  ; sets column width
	_GUICtrlListView_AddItem($list_profiles, "Item1")
	GUICtrlSetOnEvent($list_profiles, "_onLvEnter")

	; ListView Context Menu
	$lvcontext = GUICtrlCreateContextMenu($list_profiles)
	$lvcon_rename = GUICtrlCreateMenuItem($oLangStrings.lvmenu.rename, $lvcontext)
	GUICtrlSetOnEvent(-1, "_onRename")
	$lvcon_delete = GUICtrlCreateMenuItem($oLangStrings.lvmenu.delete, $lvcontext)
	GUICtrlSetOnEvent(-1, "_onDelete")
	GUICtrlCreateMenuItem("", $lvcontext)
	$lvcon_arrAz = GUICtrlCreateMenuItem($oLangStrings.lvmenu.sortAsc, $lvcontext)
	GUICtrlSetOnEvent(-1, "_onArrangeAz")
	$lvcon_arrZa = GUICtrlCreateMenuItem($oLangStrings.lvmenu.sortDesc, $lvcontext)
	GUICtrlSetOnEvent(-1, "_onArrangeZa")
	GUICtrlCreateMenuItem("", $lvcontext)
	$lvcreateLinkItem = GUICtrlCreateMenuItem($oLangStrings.lvmenu.shortcut, $lvcontext)
	GUICtrlSetOnEvent(-1, "_onCreateLink")

	$dummyUp = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onLvUp")

	$dummyDown = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onLvDown")

	;create right border
	GUICtrlCreateLabel("", $w - 1, $y, 1, $h)
	GUICtrlSetBkColor(-1, 0x666666)
	GUICtrlSetState(-1, $GUI_DISABLE)

	;create white background box
;~ 	_makeBox($x, $y, $w, $h)
	GUICtrlCreateLabel("", $x, $y, $w, $h)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState(-1, $GUI_DISABLE)
	#EndRegion profiles-list


	; ================================================
	#Region adapter-info
	$y_offset = 3 * $dscale
	$x = $xRight
	$xIndent = 5 * $dscale
	$y = $tbarHeight * $dscale + $guiSpacer + $y_offset
	$w = $wRight
	$h = 228 * $dscale
	$textSpacer = 10 * $dscale
	$textHeight = 9 * $dscale
	$bkcolor = 0xFFFFFF
	$yText_offset = $y + 9 * $dscale + 28 * $dscale

	$combo_adapters = GUICtrlCreateCombo("", $x + 8 * $dscale, $y + 8 * $dscale, $w - 16 * $dscale - 32 * $dscale, -1, BitOR($CBS_DROPDOWNlist, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetOnEvent($combo_adapters, "_OnCombo")
	$lDescription = GUICtrlCreateLabel($oLangStrings.interface.adapterDesc, $x + 8 * $dscale + $xIndent, $y + 9 * $dscale + 28 * $dscale, $w - 16 * $dscale, -1, $SS_LEFTNOWORDWRAP)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$lMac = GUICtrlCreateLabel($oLangStrings.interface.mac & ": ", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight + $textSpacer, $w - 16 * $dscale, -1, $SS_LEFTNOWORDWRAP)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)

	$combo_dummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onCombo")

;~ 	Local $aColorsEx = _
;~ 			[0xFFFFFF, 0xFCFCFC, 0xFFFFFF, _ ; normal 	: Background, Text, Border
;~ 			0xFFFFFF, 0xFCFCFC, 0xFFFFFF, _     ; focus 	: Background, Text, Border
;~ 			0xDDDDDD, 0xFCFCFC, 0xDDDDDD, _     ; hover 	: Background, Text, Border
;~ 			0xDDDDDD, 0xFCFCFC, 0xDDDDDD]     ; selected 	: Background, Text, Border

	Local $buttonRefresh = GuiFlatButton_Create("", $x + 8 * $dscale + $w - 16 * $dscale - 32 * $dscale + 5 * $dscale, $y + 8 * $dscale, 26 * $dscale, 26 * $dscale, $BS_TOOLBUTTON)
	GuiFlatButton_SetBkColor(-1, 0xFFFFFF)
	GUICtrlSetCursor(-1, 0)
;~ 	GuiFlatButton_SetColorsEx($buttonRefresh, $aColorsEx)
	_WinAPI_DeleteObject(_SendMessage(GUICtrlGetHandle($buttonRefresh), $BM_SETIMAGE, $IMAGE_ICON, _getMemoryAsIcon(GetIconData($pngRefresh24))))

	$label_sep1 = GUICtrlCreateLabel("", $x + 1, $yText_offset + $textHeight * 2 + $textSpacer * 2, $w - 2, 1)
	GUICtrlSetBkColor(-1, 0x666666)

	$yText_offset = $y + 9 * $dscale + 28 * $dscale + 5 * $dscale

	; current adapter properties
	$label_CurrIp = GUICtrlCreateLabel($oLangStrings.interface.props.ip & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 2 + $textSpacer * 2)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentIp = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 2 + $textSpacer * 2, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrSubnet = GUICtrlCreateLabel($oLangStrings.interface.props.subnet & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 3 + $textSpacer * 3)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentSubnet = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 3 + $textSpacer * 3, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrGateway = GUICtrlCreateLabel($oLangStrings.interface.props.gateway & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 4 + $textSpacer * 4)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentGateway = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 4 + $textSpacer * 4, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_sep1 = GUICtrlCreateLabel("", $x + 1, $yText_offset + $textHeight * 5 + $textSpacer * 5, $w - 2, 1)
	GUICtrlSetBkColor(-1, 0xBBBBBB)

	$yText_offset = $y + 9 * $dscale + 28 * $dscale + 5 * $dscale + 5 * $dscale

	$label_CurrDnsPri = GUICtrlCreateLabel($oLangStrings.interface.props.dnsPref & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 5 + $textSpacer * 5)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentDnsPri = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 5 + $textSpacer * 5, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrDnsAlt = GUICtrlCreateLabel($oLangStrings.interface.props.dnsAlt & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 6 + $textSpacer * 6)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentDnsAlt = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 6 + $textSpacer * 6, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_sep2 = GUICtrlCreateLabel("", $x + 1, $yText_offset + $textHeight * 7 + $textSpacer * 7, $w - 2, 1)
	GUICtrlSetBkColor(-1, 0xBBBBBB)

	$yText_offset = $y + 9 * $dscale + 28 * $dscale + 5 * $dscale + 5 * $dscale + 5 * $dscale

	$label_CurrDhcp = GUICtrlCreateLabel($oLangStrings.interface.props.dhcpServer & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 7 + $textSpacer * 7)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentDhcp = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 7 + $textSpacer * 7, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrAdapterState = GUICtrlCreateLabel($oLangStrings.interface.props.adapterState & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 8 + $textSpacer * 8)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentAdapterState = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 8 + $textSpacer * 8, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)


	_makeBox($x, $y, $w, $h)
	#EndRegion adapter-info


	; ================================================
	#Region set-ip-properties
	$x = $xRight
	$xIndent = 5 * $dscale
	$y = $tbarHeight * $dscale + $h + $guiSpacer + $y_offset + 10 * $dscale
	$w = $wRight
	$h = $guiHeight - $menuHeight - $statusbarHeight * $dscale - $guiSpacer - $footerHeight * $dscale + 2 * $dscale - $y
	$textHeight = 9 * $dscale
	$bkcolor = 0xFFFFFF

	$yText_offset = $y + 6 * $dscale
	$textSpacer = 9 * $dscale

	GUIStartGroup()
	$radio_IpAuto = GUICtrlCreateRadio($oLangStrings.interface.props.ipauto, $x + 8 * $dscale, $yText_offset, $w - 16 * $dscale, 20 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	$radio_IpMan = GUICtrlCreateRadio($oLangStrings.interface.props.ipmanual, $x + 8 * $dscale, $yText_offset + $textHeight + $textSpacer, $w - 16 * $dscale, 20 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	GUICtrlSetState(-1, $GUI_CHECKED)

	$yText_offset = $y
	$textSpacer = 17 * $dscale

	$label_ip = GUICtrlCreateLabel($oLangStrings.interface.props.ip & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 2 + $textSpacer * 2)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_Ip = _GUICtrlIpAddress_Create($hgui, $x + $w - 135 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 2 + $textSpacer * 2, 135 * $dscale, 22 * $dscale)
	_GUICtrlIpAddress_SetFontByHeight($ip_Ip, $MyGlobalFontName, $MyGlobalFontHeight)

	$label_subnet = GUICtrlCreateLabel($oLangStrings.interface.props.subnet & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 3 + $textSpacer * 3)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_Subnet = _GUICtrlIpAddress_Create($hgui, $x + $w - 135 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 3 + $textSpacer * 3, 135 * $dscale, 22 * $dscale)
	_GUICtrlIpAddress_SetFontByHeight($ip_Subnet, $MyGlobalFontName, $MyGlobalFontHeight)

	$label_gateway = GUICtrlCreateLabel($oLangStrings.interface.props.gateway & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 4 + $textSpacer * 4)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_Gateway = _GUICtrlIpAddress_Create($hgui, $x + $w - 135 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 4 + $textSpacer * 4, 135 * $dscale, 22 * $dscale)
	_GUICtrlIpAddress_SetFontByHeight($ip_Gateway, $MyGlobalFontName, $MyGlobalFontHeight)


	; ------------------
	; DNS PROPERTIES
	; ------------------
	$yText_offset = $y + 45 * $dscale
	$textSpacer = 9 * $dscale

	$label_sep1 = GUICtrlCreateLabel("", $x + 1, $yText_offset + $textHeight * 5 + $textSpacer * 5, $w - 2, 1)
	GUICtrlSetBkColor(-1, 0xBBBBBB)

	$yText_offset = $y + 50 * $dscale

	GUIStartGroup()
	$radio_DnsAuto = GUICtrlCreateRadio($oLangStrings.interface.props.dnsauto, $x + 8 * $dscale, $yText_offset + $textHeight * 5 + $textSpacer * 5, $w - 16 * $dscale, 20 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	$radio_DnsMan = GUICtrlCreateRadio($oLangStrings.interface.props.dnsmanual, $x + 8 * $dscale, $yText_offset + $textHeight * 6 + $textSpacer * 6, $w - 16 * $dscale, 20 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	GUICtrlSetState(-1, $GUI_CHECKED)

	$yText_offset = $y
	$textSpacer = 17 * $dscale

	$label_DnsPri = GUICtrlCreateLabel($oLangStrings.interface.props.dnsPref & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 7 + $textSpacer * 7)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_DnsPri = _GUICtrlIpAddress_Create($hgui, $x + $w - 135 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 7 + $textSpacer * 7, 135 * $dscale, 22 * $dscale)
	_GUICtrlIpAddress_SetFontByHeight($ip_DnsPri, $MyGlobalFontName, $MyGlobalFontHeight)

	$label_DnsAlt = GUICtrlCreateLabel($oLangStrings.interface.props.dnsAlt & ":", $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 8 + $textSpacer * 8)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_DnsAlt = _GUICtrlIpAddress_Create($hgui, $x + $w - 135 * $dscale - 8 * $dscale, $yText_offset + $textHeight * 8 + $textSpacer * 8, 135 * $dscale, 22 * $dscale)
	_GUICtrlIpAddress_SetFontByHeight($ip_DnsAlt, $MyGlobalFontName, $MyGlobalFontHeight)

	$ck_dnsReg = GUICtrlCreateCheckbox($oLangStrings.interface.props.dnsreg, $x + 8 * $dscale + $xIndent, $yText_offset + $textHeight * 9 + $textSpacer * 9, -1, 15 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 8.5)

	;MAKE THE APPLY BUTTON
	Local $aColorsEx = _
			[0x73f773, 0x111111, 0x666666, _     ; normal 	: Background, Text, Border
			0x8ef98e, 0x111111, 0x999999, _     ; focus 	: Background, Text, Border
			0xbbfbbb, 0x333333, 0x666666, _      ; hover 	: Background, Text, Border
			0x73f773, 0x111111, 0x666666]        ; selected 	: Background, Text, Border

	$tbButtonApply = GuiFlatButton_Create($oLangStrings.toolbar.apply, $x + 8 * $dscale, $yText_offset + $textHeight * 10 + $textSpacer * 10, $wRight - 2 * (8 * $dscale), 50 * $dscale)
	GUICtrlSetTip(-1, $oLangStrings.toolbar.apply_tip)
	GUICtrlSetOnEvent(-1, "_apply_GUI")
	GuiFlatButton_SetColorsEx($tbButtonApply, $aColorsEx)


	_makeBox($x, $y, $w, $h)
	#EndRegion set-ip-properties


	; =================================================
	#Region accelerators
	$deletedummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onLvDel")
	$tabdummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onTabKey")

	$aAccelKeys[0][0] = '{ENTER}'
	$aAccelKeys[0][1] = $list_profiles
	$aAccelKeys[1][0] = '^r'
	$aAccelKeys[1][1] = $refreshitem
	$aAccelKeys[2][0] = '{F2}'
	$aAccelKeys[2][1] = $renameitem
	$aAccelKeys[3][0] = '{DEL}'
	$aAccelKeys[3][1] = $deletedummy
	$aAccelKeys[4][0] = '^s'
	$aAccelKeys[4][1] = $saveitem
	$aAccelKeys[5][0] = '^n'
	$aAccelKeys[5][1] = $newitem
	$aAccelKeys[6][0] = '^p'
	$aAccelKeys[6][1] = $pullitem
	$aAccelKeys[7][0] = '^t'
	$aAccelKeys[7][1] = $send2trayitem
	$aAccelKeys[8][0] = '{F1}'
	$aAccelKeys[8][1] = $helpitem
	$aAccelKeys[9][0] = '{UP}'
	$aAccelKeys[9][1] = $dummyUp
	$aAccelKeys[10][0] = '{DOWN}'
	$aAccelKeys[10][1] = $dummyDown
	$aAccelKeys[11][0] = '{TAB}'
	$aAccelKeys[11][1] = $tabdummy
	GUISetAccelerators($aAccelKeys)
	#EndRegion accelerators



	If IsObj($profiles) Then
		If $profiles.count > 0 Then
			Local $profileNames = $profiles.getNames()
			$profileName = $profileNames[0]
			_setProperties(1, $profileName)
		EndIf
	EndIf

	$sStartupMode = $options.StartupMode
	If $sStartupMode <> "1" And $sStartupMode <> "true" Then
		GUISetState(@SW_SHOW, $hgui)
	Else
		TrayItemSetText($RestoreItem, $oLangStrings.traymenu.restore)
	EndIf
	$prevWinPos = WinGetPos($hgui)
EndFunc   ;==>_form_main


Func _colorChangeLightness($baseColor, $lightness = 1)
	Local $baseRGB = _ColorGetRGB($baseColor)
	Local $baseHSL = _ColorConvertRGBtoHSL($baseRGB)
	Local $newL = $lightness * $baseHSL[2]
	If $newL < 0 Then $newL = 0
	If $newL > 100 Then $newL = 100
	Local $darkenHSL[3] = [$baseHSL[0], $baseHSL[1], $newL]
	Local $darkenRGB = _ColorConvertHSLtoRGB($darkenHSL)
	Return _ColorSetRGB($darkenRGB)
EndFunc   ;==>_colorChangeLightness


Func _makeCurrentProps($label, $x, $y, $w, $h)
	Local $aRet = _makeHeading($label, $x + 1, $y + 1, $w - 2, -1, 0x0782FD, 0.95)
	$headingCurrent = $aRet[0]
	Local $headingHeight = $aRet[1]
	Local $bkcolor = 0xEEEEEE

	$label_CurrIp = GUICtrlCreateLabel($oLangStrings.interface.props.ip & ":", $x + 8 * $dscale, $y + $headingHeight + 8 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentIp = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $y + $headingHeight + 8 * $dscale, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrSubnet = GUICtrlCreateLabel($oLangStrings.interface.props.subnet & ":", $x + 8 * $dscale, $y + $headingHeight + 25 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentSubnet = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $y + $headingHeight + 25 * $dscale, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrGateway = GUICtrlCreateLabel($oLangStrings.interface.props.gateway & ":", $x + 8 * $dscale, $y + $headingHeight + 42 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentGateway = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $y + $headingHeight + 42 * $dscale, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_sep1 = GUICtrlCreateLabel("", $x + 1, $y + $headingHeight + 62 * $dscale, $w - 2, 1)
;~ 	GUICtrlSetBkColor(-1, 0x0051FF)
	GUICtrlSetBkColor(-1, 0x404040)

	$label_CurrDnsPri = GUICtrlCreateLabel($oLangStrings.interface.props.dnsPref & ":", $x + 8 * $dscale, $y + $headingHeight + 67 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentDnsPri = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $y + $headingHeight + 67 * $dscale, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrDnsAlt = GUICtrlCreateLabel($oLangStrings.interface.props.dnsAlt & ":", $x + 8 * $dscale, $y + $headingHeight + 84 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentDnsAlt = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $y + $headingHeight + 84 * $dscale, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_sep2 = GUICtrlCreateLabel("", $x + 1, $y + $headingHeight + 105 * $dscale, $w - 2, 1)
;~ 	GUICtrlSetBkColor(-1, 0x0051FF)
	GUICtrlSetBkColor(-1, 0x404040)

	$label_CurrDhcp = GUICtrlCreateLabel($oLangStrings.interface.props.dhcpServer & ":", $x + 8 * $dscale, $y + $headingHeight + 112 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentDhcp = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $y + $headingHeight + 112 * $dscale, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrAdapterState = GUICtrlCreateLabel($oLangStrings.interface.props.adapterState & ":", $x + 8 * $dscale, $y + $headingHeight + 129 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentAdapterState = GUICtrlCreateInput("", $x + $w - 125 * $dscale - 8 * $dscale, $y + $headingHeight + 129 * $dscale, 125 * $dscale, 15 * $dscale, BitOR($ES_READONLY, $SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	_makeBox($x, $y, $w, $h, $bkcolor)
EndFunc   ;==>_makeCurrentProps

Func _makeDnsProps($label, $x, $y, $w, $h)
	Local $aRet = _makeHeading($label, $x + 1, $y + 1, $w - 2, 5, 0x0782FD, 0.95)
	Local $headingHeight = $aRet[1]
	GUIStartGroup()
	$radio_DnsAuto = GUICtrlCreateRadio($oLangStrings.interface.props.dnsauto, $x + 8 * $dscale, $y + $headingHeight + 4 * $dscale, $w - 16 * $dscale, 20 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	$radio_DnsMan = GUICtrlCreateRadio($oLangStrings.interface.props.dnsmanual, $x + 8 * $dscale, $y + $headingHeight + 23 * $dscale, $w - 16 * $dscale, 20 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	GUICtrlSetState(-1, $GUI_CHECKED)

	$label_DnsPri = GUICtrlCreateLabel($oLangStrings.interface.props.dnsPref & ":", $x + 8 * $dscale, $y + $headingHeight + 51 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_DnsPri = _GUICtrlIpAddress_Create($hgui, $x + $w - 135 * $dscale - 8 * $dscale, $y + $headingHeight + 48 * $dscale, 135 * $dscale, 22 * $dscale)
	_GUICtrlIpAddress_SetFontByHeight($ip_DnsPri, $MyGlobalFontName, $MyGlobalFontHeight)

	$label_DnsAlt = GUICtrlCreateLabel($oLangStrings.interface.props.dnsAlt & ":", $x + 8 * $dscale, $y + $headingHeight + 77 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_DnsAlt = _GUICtrlIpAddress_Create($hgui, $x + $w - 135 * $dscale - 8 * $dscale, $y + $headingHeight + 74 * $dscale, 135 * $dscale, 22 * $dscale)
	_GUICtrlIpAddress_SetFontByHeight($ip_DnsAlt, $MyGlobalFontName, $MyGlobalFontHeight)

	$ck_dnsReg = GUICtrlCreateCheckbox($oLangStrings.interface.props.dnsreg, $x + 8 * $dscale, $y + $h - 19 * $dscale, -1, 15 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 8.5)

	_makeBox($x, $y, $w, $h)
EndFunc   ;==>_makeDnsProps

Func _makeIpProps($label, $x, $y, $w, $h)
	Local $aRet = _makeHeading($label, $x + 1, $y + 1, $w - 2, -1, 0x0782FD, 0.95)
	$headingIP = $aRet[0]
	Local $headingHeight = $aRet[1]
	GUIStartGroup()
	$radio_IpAuto = GUICtrlCreateRadio($oLangStrings.interface.props.ipauto, $x + 8 * $dscale, $y + $headingHeight + 4 * $dscale, $w - 16 * $dscale, 20 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	$radio_IpMan = GUICtrlCreateRadio($oLangStrings.interface.props.ipmanual, $x + 8 * $dscale, $y + $headingHeight + 23 * $dscale, $w - 16 * $dscale, 20 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	GUICtrlSetState(-1, $GUI_CHECKED)

	$label_ip = GUICtrlCreateLabel($oLangStrings.interface.props.ip & ":", $x + 8 * $dscale, $y + $headingHeight + 51 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_Ip = _GUICtrlIpAddress_Create($hgui, $x + $w - 135 * $dscale - 8 * $dscale, $y + $headingHeight + 48 * $dscale, 135 * $dscale, 22 * $dscale)
	_GUICtrlIpAddress_SetFontByHeight($ip_Ip, $MyGlobalFontName, $MyGlobalFontHeight)

	$label_subnet = GUICtrlCreateLabel($oLangStrings.interface.props.subnet & ":", $x + 8 * $dscale, $y + $headingHeight + 77 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_Subnet = _GUICtrlIpAddress_Create($hgui, $x + $w - 135 * $dscale - 8 * $dscale, $y + $headingHeight + 74 * $dscale, 135 * $dscale, 22 * $dscale)
	_GUICtrlIpAddress_SetFontByHeight($ip_Subnet, $MyGlobalFontName, $MyGlobalFontHeight)

	$label_gateway = GUICtrlCreateLabel($oLangStrings.interface.props.gateway & ":", $x + 8 * $dscale, $y + $headingHeight + 103 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_Gateway = _GUICtrlIpAddress_Create($hgui, $x + $w - 135 * $dscale - 8 * $dscale, $y + $headingHeight + 100 * $dscale, 135 * $dscale, 22 * $dscale)
	_GUICtrlIpAddress_SetFontByHeight($ip_Gateway, $MyGlobalFontName, $MyGlobalFontHeight)

	_makeBox($x, $y, $w, $h)
EndFunc   ;==>_makeIpProps

Func _makeProfileSelect($label, $x, $y, $w, $h)
	Local $aRet = _makeHeading($label, $x + 1, $y + 1, $w - 2, -1, 0x0782FD, 0.95)
	$headingProfiles = $aRet[0]
	Local $headingHeight = $aRet[1]
	$searchgraphic = GUICtrlCreatePic("", $x + 5, $y + $headingHeight + 3 + 2 * $dscale, 16, 16)
	;_ResourceSetImageToCtrl($hGUI, $searchgraphic, "search_png")
	_memoryToPic($searchgraphic, GetIconData($pngSearch))

	$input_filter = GUICtrlCreateInput("*", $x + 12 + 11, $y + $headingHeight + 3 + 2 * $dscale, $w - 12 - 18, 15 * $dscale, -1, $WS_EX_TOOLWINDOW)
	GUICtrlCreateLabel("", $x + 3, $y + $headingHeight + 3, $w - 6, 20 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlCreateLabel("", $x + 2, $y + $headingHeight + 2, $w - 4, 20 * $dscale + 2)
	GUICtrlSetBkColor(-1, 0x777777)
	$filter_dummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent($filter_dummy, "_onFilter")

	$list_profiles = GUICtrlCreateListView($label, $x + 1, $y + $headingHeight + 2 + 20 * $dscale + 3, $w - 2, $h - $headingHeight - 3 - 20 * $dscale - 3 - 1, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOCOLUMNHEADER, $LVS_EDITLABELS), $WS_EX_TRANSPARENT)
	_GUICtrlListView_SetColumnWidth($list_profiles, 0, $w - 2 - 20 * $dscale)  ; sets column width
	_GUICtrlListView_AddItem($list_profiles, "Item1")
	GUICtrlSetOnEvent($list_profiles, "_onLvEnter")

	; ListView Context Menu
	$lvcontext = GUICtrlCreateContextMenu($list_profiles)
	$lvcon_rename = GUICtrlCreateMenuItem($oLangStrings.lvmenu.rename, $lvcontext)
	GUICtrlSetOnEvent(-1, "_onRename")
	$lvcon_delete = GUICtrlCreateMenuItem($oLangStrings.lvmenu.delete, $lvcontext)
	GUICtrlSetOnEvent(-1, "_onDelete")
	GUICtrlCreateMenuItem("", $lvcontext)
	$lvcon_arrAz = GUICtrlCreateMenuItem($oLangStrings.lvmenu.sortAsc, $lvcontext)
	GUICtrlSetOnEvent(-1, "_onArrangeAz")
	$lvcon_arrZa = GUICtrlCreateMenuItem($oLangStrings.lvmenu.sortDesc, $lvcontext)
	GUICtrlSetOnEvent(-1, "_onArrangeZa")
	GUICtrlCreateMenuItem("", $lvcontext)
	$lvcreateLinkItem = GUICtrlCreateMenuItem($oLangStrings.lvmenu.shortcut, $lvcontext)
	GUICtrlSetOnEvent(-1, "_onCreateLink")

	$dummyUp = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onLvUp")

	$dummyDown = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onLvDown")

	_makeBox($x, $y, $w, $h)
EndFunc   ;==>_makeProfileSelect

Func _makeComboSelect($label, $x, $y, $w, $h)
	Local $aRet = _makeHeading($label, $x + 1, $y + 1, $w - 2, -1, 0x0782FD, 0.95)
	$headingSelect = $aRet[0]
	Local $headingHeight = $aRet[1]

	$combo_adapters = GUICtrlCreateCombo("", $x + 8 * $dscale, $y + $headingHeight + 8 * $dscale, $w - 16 * $dscale, -1, BitOR($CBS_DROPDOWNlist, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetOnEvent($combo_adapters, "_OnCombo")
	_setFont($combo_adapters, $MyGlobalFontSize)
	$lDescription = GUICtrlCreateLabel($oLangStrings.interface.adapterDesc, $x + 8 * $dscale, $y + $headingHeight + 9 * $dscale + 26 * $dscale, $w - 16 * $dscale, -1, $SS_LEFTNOWORDWRAP)
	_setFont($lDescription, 8.5, $MyGlobalFontBKColor)
	$lMac = GUICtrlCreateLabel($oLangStrings.interface.mac & ": ", $x + 8 * $dscale, $y + $headingHeight + 9 * $dscale + 41 * $dscale, $w - 16 * $dscale, -1, $SS_LEFTNOWORDWRAP)
	_setFont($lMac, 8.5, $MyGlobalFontBKColor)

	$combo_dummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onCombo")

	_makeBox($x, $y, $w, $h)
EndFunc   ;==>_makeComboSelect



; Create Header
Func _makeHeading($sLabel, $x, $y, $w, $height = -1, $color = -1, $lightness = -1)
	$strSize = _StringSize($sLabel, 8.5, 400, 0, "Segoe UI")
	$labelX = ($w - $strSize[2] * $dscale) / 2 + $x
	$h = $strSize[3] - 2
	If $height <> -1 Then
		$h = $height
	EndIf
	$labelY = $y

	Local $heading = GUICtrlCreateLabel($sLabel, $labelX, $labelY)
	_setFont($heading, 8.5)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

;~ 	If $color = -1 Then
;~ 		Local $bottomline = GUICtrlCreateLabel( "", $x, $y+$h-1, $w, 1 )
;~ 	GUICtrlSetBkColor(-1, 0x000880)
;~ 		GUICtrlSetBkColor(-1, 0x404040)
;~ 	EndIf

	;Local $bg = GUICtrlCreateLabel( "", $x, $y, $w, $h )
	;GUICtrlSetBkColor(-1, 0x5C67FF)

	Local $idPic = GUICtrlCreatePic('', $x, $y, $w, $h)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $hPic = GUICtrlGetHandle($idPic)

	; Create gradient
	Local $hDC = _WinAPI_GetDC($hPic)
	Local $hDestDC = _WinAPI_CreateCompatibleDC($hDC)
	Local $hBitmap = _WinAPI_CreateCompatibleBitmap($hDC, $w, $h)
	Local $hDestSv = _WinAPI_SelectObject($hDestDC, $hBitmap)

	Local $baseColor = 0x0782FD
	Local $lightFactor = 0.75
	If $color <> -1 Then
		$baseColor = $color
		$lightFactor = $lightness
	EndIf

	$baseRGB = _ColorGetRGB($baseColor)
	$baseHSL = _ColorConvertRGBtoHSL($baseRGB)
	$newL = $lightFactor * $baseHSL[2]
	If $newL < 0 Then $newL = 0
	Local $darkenHSL[3] = [$baseHSL[0], $baseHSL[1], $newL]
	$darkenRGB = _ColorConvertHSLtoRGB($darkenHSL)
	$darkenColor = _ColorSetRGB($darkenRGB)

	Local $aVertex[6][3] = [[0, 0, $baseColor], [$w, $h, $darkenColor], [0, 0, $baseColor], [$w, $h - $h / 4, $darkenColor], [0, $h - $h / 4, $darkenColor], [$w, $h, $baseColor]]
	If $color = -1 Then
		_WinAPI_GradientFill($hDestDC, $aVertex, 0, 1)
	Else
		_WinAPI_GradientFill($hDestDC, $aVertex, 2, 3)
		_WinAPI_GradientFill($hDestDC, $aVertex, 4, 5)
	EndIf

	_WinAPI_ReleaseDC($hPic, $hDC)
	_WinAPI_SelectObject($hDestDC, $hDestSv)
	_WinAPI_DeleteDC($hDestDC)

	; Set gradient to control
	_SendMessage($hPic, 0x0172, 0, $hBitmap)
	Local $hObj = _SendMessage($hPic, 0x0173)
	If $hObj <> $hBitmap Then
		_WinAPI_DeleteObject($hBitmap)
	EndIf

	Local $aRet[2]
	$aRet[0] = $heading
	$aRet[1] = $h
	Return $aRet
EndFunc   ;==>_makeHeading

; Create Section Box
Func _makeBox($x, $y, $w, $h, $bkcolor = 0xFFFFFF)
	Local $bg = GUICtrlCreateLabel("", $x + 1, $y + 1, $w - 2, $h - 2)
	GUICtrlSetBkColor(-1, $bkcolor)

	Local $border = GUICtrlCreateLabel("", $x, $y, $w, $h)
;~ 	GUICtrlSetBkColor(-1, 0x000880)
	GUICtrlSetBkColor(-1, 0x666666)
EndFunc   ;==>_makeBox

#Region -- Helper Functions --
Func _setFont($ControlID, $size, $bkcolor = -1, $color = 0x000000)
	Local $LControlID
	If $ControlID = -1 Then
		$LControlID = _GUIGetLastCtrlID()
	Else
		$LControlID = $ControlID
	EndIf
	GUICtrlSetFont($LControlID, $size)
	GUICtrlSetColor(-1, $color)
	If $bkcolor <> -1 Then
		GUICtrlSetBkColor(-1, $bkcolor)
	EndIf
EndFunc   ;==>_setFont

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified By....: Kurtis Liggett
; ===============================================================================================================================
Func _GUICtrlIpAddress_SetFontByHeight($hWnd, $sFaceName = "Arial", $iFontSize = 12, $iFontWeight = 400, $bFontItalic = False)
	Local $hDC = _WinAPI_GetDC(0)
	;Local $iHeight = Round(($iFontSize * _WinAPI_GetDeviceCaps($hDC, $__IPADDRESSCONSTANT_LOGPIXELSX)) / 72, 0)
	Local $iHeight = $iFontSize
	_WinAPI_ReleaseDC(0, $hDC)

	Local $tFont = DllStructCreate($tagLOGFONT)
	DllStructSetData($tFont, "Height", $iHeight)
	DllStructSetData($tFont, "Weight", $iFontWeight)
	DllStructSetData($tFont, "Italic", $bFontItalic)
	DllStructSetData($tFont, "Underline", False) ; font underline
	DllStructSetData($tFont, "Strikeout", False) ; font strikethru
	DllStructSetData($tFont, "Quality", $__IPADDRESSCONSTANT_PROOF_QUALITY)
	DllStructSetData($tFont, "FaceName", $sFaceName)

	Local $hFont = _WinAPI_CreateFontIndirect($tFont)
	_WinAPI_SetFont($hWnd, $hFont)
EndFunc   ;==>_GUICtrlIpAddress_SetFontByHeight

Func _GUIGetLastCtrlID()
	Local $aRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", GUICtrlGetHandle(-1))
	Return $aRet[0]
EndFunc   ;==>_GUIGetLastCtrlID

; #FUNCTION# ====================================================================================================================
; Name ..........: _GDIPlus_GraphicsGetDPIRatio
; Description ...:
; Syntax ........: _GDIPlus_GraphicsGetDPIRatio([$iDPIDef = 96])
; Parameters ....: $iDPIDef             - [optional] An integer value. Default is 96.
; Return values .: None
; Author ........: UEZ
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/159612-dpi-resolution-problem/?hl=%2Bdpi#entry1158317
; Example .......: No
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetDPIRatio($iDPIDef = 96)
	_GDIPlus_Startup()
	Local $hGfx = _GDIPlus_GraphicsCreateFromHWND(0)
	If @error Then Return SetError(1, @extended, 0)
	Local $aResult
	#forcedef $__g_hGDIPDll, $ghGDIPDll

	$aResult = DllCall($__g_hGDIPDll, "int", "GdipGetDpiX", "handle", $hGfx, "float*", 0)

	If @error Then Return SetError(2, @extended, 0)
	Local $iDPI = $aResult[2]
	Local $aresults[2] = [$iDPIDef / $iDPI, $iDPI / $iDPIDef]
	_GDIPlus_GraphicsDispose($hGfx)
	_GDIPlus_Shutdown()
;~ 	ConsoleWrite("DPI Ratio: " & $aresults[1]&@CRLF)
	Return $aresults[1]
EndFunc   ;==>_GDIPlus_GraphicsGetDPIRatio

Func _getDpiScale()
	Local $hDC = _WinAPI_GetDC(0)
	Local $DPI = _WinAPI_GetDeviceCaps($hDC, $LOGPIXELSY)
	_WinAPI_ReleaseDC(0, $hDC)

	Select
		Case $DPI = 0
			$DPI = 1
		Case $DPI < 84
			$DPI /= 105
		Case $DPI < 121
			$DPI /= 96
		Case $DPI < 145
			$DPI /= 95
		Case Else
			$DPI /= 94
	EndSelect

	Return Round($DPI, 2)
EndFunc   ;==>_getDpiScale
#EndRegion -- Helper Functions --



; Status Message Popup
Func _statusPopup()
	$wPos = WinGetPos($hgui)

;~ 	$w = $guiWidth*$dScale
;~ 	$h = 250*$dScale
;~ 	$x = $wPos[0] + ($wPos[2]-$w)/2
;~ 	$y = $wPos[1] + $menuHeight + $guiheight*$dscale-$h + 1

	$w = $guiWidth * $dScale
	$h = 100 * $dScale
	$x = 0
	$y = $guiheight * $dscale - $h - $menuHeight

	$statusChild = GUICreate("StatusMessage", $w, $h, $x, $y, $WS_POPUP, $WS_EX_TOOLWINDOW)
	_WinAPI_SetParent($statusChild, $hgui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)
	GUISetBkColor(_WinAPI_GetSysColor($COLOR_MENUBAR), $statusChild)

	$pic = GUICtrlCreatePic("", 3 * $dScale, 3 * $dScale, 16, 16)
	_memoryToPic($pic, GetIconData($pngWarning))

	GUICtrlCreateLabel($oLangStrings.message.errorOccurred, 27 * $dscale, 4 * $dscale, 200 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	$edit = GUICtrlCreateEdit(GUICtrlRead($statuserror), 5, 23, $w - 10, $h - 37 * $dscale - 23, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_NOHIDESEL, $ES_READONLY), $WS_EX_TRANSPARENT)
	GUICtrlSetFont(-1, 8.5)
	Send("^{HOME}")

	GUICtrlCreateLabel("", 0, 1, $w, 1)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel("", 0, 0, $w, 1)
	GUICtrlSetBkColor(-1, 0x404040)

	$bt_Ok = GUICtrlCreateButton("OK", $w - 55 * $dScale, $h - 27 * $dScale, 50 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent(-1, "_onExitChild")

	;GUISetState(@SW_DISABLE, $hGUI)
	GUISetState(@SW_SHOW, $statusChild)

	;Switch to the parent window
	GUISwitch($hgui)
EndFunc   ;==>_statusPopup
