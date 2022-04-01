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
#EndRegion

;==============================================================================
; Filename:		gui.au3
; Description:	- GUI creation and related functions
;				- child window creation functions
;==============================================================================

#Region -- MAIN GUI CREATION --
Func _makeGUI()
	; GUI FORMATTING
	$ixCoordMin = _WinAPI_GetSystemMetrics(76)
	$iyCoordMin = _WinAPI_GetSystemMetrics(77)
	$iFullDesktopWidth = _WinAPI_GetSystemMetrics(78)
	$iFullDesktopHeight = _WinAPI_GetSystemMetrics(79)
	$sPositionX = Options_GetValue($options, $OPTIONS_PositionX)
	If $sPositionX <> "" Then
		$xpos = $sPositionX
		If $xpos > ($ixCoordMin+$iFullDesktopWidth) Then
			$xpos = $iFullDesktopWidth-($guiWidth*$dscale)
		ElseIf $xpos < $ixCoordMin Then
			$xpos = 1
		EndIf
	Else
		$xpos = @DesktopWidth/2-$guiWidth*$dscale/2
	EndIf
	$sPositionY = Options_GetValue($options, $OPTIONS_PositionY)
	If $sPositionY <> "" Then
		$ypos = $sPositionY
		If $ypos > ($iyCoordMin+$iFullDesktopHeight) Then
			$ypos = $iFullDesktopHeight-($guiHeight*$dscale)
		ElseIf $ypos < $iyCoordMin Then
			$ypos = 1
		EndIf
	Else
		$ypos = @DesktopHeight/2-$guiHeight*$dscale/2
	EndIf

	;$hgui = GUICreate( $winName & " " & $winVersion, $guiWidth*$dscale, $guiHeight*$dscale, @DesktopWidth/2-$guiWidth*$dscale/2, @DesktopHeight/2-$guiHeight*$dscale/2, BITOR($GUI_SS_DEFAULT_GUI,$WS_CLIPCHILDREN, $WS_SIZEBOX), $WS_EX_COMPOSITED )
	$hgui = GUICreate( $winName & " " & $winVersion, $guiWidth*$dscale, $guiHeight*$dscale, $xpos, $ypos, BITOR($GUI_SS_DEFAULT_GUI,$WS_CLIPCHILDREN), $WS_EX_COMPOSITED )
	GUISetBkColor( 0xFFFFFF)

	GUISetFont ( $MyGlobalFontSize, -1, -1, $MyGlobalFontName )
	_GDIPlus_Startup()

	$strSize = _StringSize("{", $MyGlobalFontSize,  400, 0 , $MyGlobalFontName)
	$MyGlobalFontHeight = $strSize[1]

	_makeMenu()
	_makeToolbar()
	_makeStatusbar()
	Local $guiSpacer = 0
	Local $y = 0
	Local $xLeft = $guiSpacer
	Local $wLeft = 230*$dscale
	Local $xRight = $xLeft + $wLeft
	Local $wRight = $guiWidth*$dscale - $wLeft - 2*$guiSpacer
	_makeComboSelect($oLangStrings.interface.select, $xLeft, $tbarHeight*$dscale + $guiSpacer+$y, $wLeft, 88*$dscale)
	$hLeft = $tbarHeight*$dscale + $guiSpacer + 88*$dscale+$y
	_makeProfileSelect($oLangStrings.interface.profiles, $xLeft, $tbarHeight*$dscale + $guiSpacer + 87*$dscale+$y, $wLeft, $guiHeight*$dscale-$hLeft-$menuHeight-$statusbarHeight*$dscale-$guiSpacer-$footerHeight*$dscale+1*$dscale)

	_makeIpProps($oLangStrings.interface.profileprops, $xRight, $tbarHeight*$dscale + $guiSpacer+$y, $wRight, 148*$dscale)
	_makeDnsProps("", $xRight, $tbarHeight*$dscale + $guiSpacer + 147*$dscale+$y, $wRight, 130*$dscale)
	$hRight = $tbarHeight*$dscale + $guiSpacer + 148*$dscale + 130*$dscale
	_makeCurrentProps($oLangStrings.interface.currentprops, $xRight, $tbarHeight*$dscale + $guiSpacer + 148*$dscale + 129*$dscale, $wRight, $guiHeight*$dscale-$hRight-$menuHeight-$statusbarHeight*$dscale-$guiSpacer-$footerHeight*$dscale+1*$dscale)
	_makeFooter()

;~ 	$but = GUICtrlCreateButton("get", 10, 50, 100,25)
;~ 	GUICtrlSetOnEvent(-1, "_getIP")
;~ 	$babout = GUICtrlCreateButton("About", 100, 50, 100,25)
;~ 	GUICtrlSetOnEvent(-1, "_about")

	; GUI SET EVENTS
	GUISetOnEvent( $GUI_EVENT_CLOSE, "_onExit")
	GUISetOnEvent( $GUI_EVENT_MINIMIZE, "_minimize")
	GUISetOnEvent( $GUI_EVENT_RESTORE, "_maximize")
	GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "_clickDn")
	GUISetOnEvent($GUI_EVENT_PRIMARYUP, "_clickUp")

	GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
	GUIRegisterMsg($WM_NOTIFY, 'WM_NOTIFY')

	$deletedummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onLvDel")
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
	$aAccelKeys[9][0] = '^c'
	$aAccelKeys[9][1] = $clearitem
	$aAccelKeys[10][0] = '{UP}'
	$aAccelKeys[10][1] = $dummyUp
	$aAccelKeys[11][0] = '{DOWN}'
	$aAccelKeys[11][1] = $dummyDown
;~ 	$aAccelKeys[12][0] = '{TAB}'
;~ 	$aAccelKeys[12][1] = $dummyTab
	GUISetAccelerators($aAccelKeys)

	;WinWaitActive ( $hgui, "", 3 )
	;~ Set up tray menu
	$RestoreItem      = TrayCreateItem($oLangStrings.traymenu.hide)
	TrayItemSetOnEvent(-1, "_OnRestore")
	$aboutitem      = TrayCreateItem($oLangStrings.traymenu.about)
	TrayItemSetOnEvent(-1, "_onAbout")
	TrayCreateItem("")
	$exititem       = TrayCreateItem($oLangStrings.traymenu.exit)
	TrayItemSetOnEvent(-1, "_onExit")
	TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, "_OnTrayClick")
	TraySetToolTip ( $winName )

	GUICtrlCreateLabel("",0,0,$guiWidth*$dscale,$guiHeight*$dscale)
	;GUICtrlSetBkColor(-1,0xC9C9C9)
	GUICtrlSetBkColor(-1,0x666666)

	If IsArray($profiles) Then
		If Profiles_GetSize($profiles) > 0 Then
			Local $profileNames = Profiles_GetNames($profiles)
			$profileName = $profilenames[0]
			_setProperties(1,$profileName)
		EndIf
	EndIf

	$sStartupMode = Options_GetValue($options, $OPTIONS_StartupMode)
	If $sStartupMode <> "1" and $sStartupMode <> "true" Then
		GUISetState(@SW_SHOW, $hgui)
		GUISetState(@SW_SHOWNOACTIVATE, $hTool)
		GUISetState(@SW_SHOWNOACTIVATE, $hTool2)

		GUISetState(@SW_SHOW, $hgui)
		GUISetState(@SW_SHOWNOACTIVATE, $hTool)
		GUISetState(@SW_SHOWNOACTIVATE, $hTool2)
	Else
		TrayItemSetText( $RestoreItem, $oLangStrings.traymenu.restore )
	EndIf
	$prevWinPos = WinGetPos($hgui)
EndFunc

Func _makeFooter()
	$x = 0
	$y = $guiheight*$dscale - $statusbarHeight*$dscale - $footerHeight*$dscale -  $menuHeight
	$w = $guiWidth*$dscale
	$h = $footerHeight*$dscale

	GUICtrlCreateLabel("", $x, $y, $w, 1)
	GUICtrlSetBkColor(-1, 0x404040)

	If $screenshot Then
		$computerName = GUICtrlCreateLabel($oLangStrings.interface.computername & ": ________", $x+3, $y+2, $w, $h)
	Else
		$computerName = GUICtrlCreateLabel($oLangStrings.interface.computername & ": " & @ComputerName, $x+3, $y+2, $w, $h)
	EndIf
	GUICtrlSetBkColor($computerName, $GUI_BKCOLOR_TRANSPARENT)
	_setFont($computerName, 8, -1, 0xFFFFFF)

	If @LogonDomain <> "" Then
		$domainName = GUICtrlCreateLabel("", $x, $y+2, $w-3, $h, $SS_RIGHT)
		GUICtrlSetBkColor($domainName, $GUI_BKCOLOR_TRANSPARENT)
		_setFont($domainName, 8, -1, 0xFFFFFF)
	EndIf

	;_makeHeading("", $x, $y, $w, $h, 0x0782FD, 0.95)
EndFunc

Func _makeStatusbar()
	$y = $guiHeight*$dscale - $statusbarHeight*$dscale - $menuHeight
	$x = 0
	$w = $guiWidth*$dscale
	$h = $statusbarHeight*$dscale

	$wgraphic = GUICtrlCreatePic("", $w-20, $y+2*$dscale, 16, 16)
	_memoryToPic($wgraphic, GetIconData($pngWarning))
	GUICtrlSetOnEvent(-1, "_statusPopup")
	GUICtrlSetState($wgraphic, $GUI_HIDE)
	GUICtrlSetCursor($wgraphic, 0)

	$statustext = GUICtrlCreateLabel ( "Ready", $x+3, $y+3, $w-2, $h-2)
	GUICtrlSetBkColor (-1, $GUI_BKCOLOR_TRANSPARENT)

	$statuserror = GUICtrlCreateLabel ( "", $x+3, $y+3, $w-2, $h-2)
	GUICtrlSetBkColor (-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetOnEvent(-1, "_statusPopup")
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetState($statuserror, $GUI_HIDE)

	GUICtrlCreateLabel ( "", $x, $y+1, $w, 1)
	GUICtrlSetBkColor (-1, 0xFFFFFF)

	GUICtrlCreateLabel ( "", $x, $y, $w, 1)
	GUICtrlSetBkColor (-1, 0x404040)

	GUICtrlCreateLabel ( "", $x, $y, $w, $h)
	GUICtrlSetBkColor (-1, _WinAPI_GetSysColor($COLOR_MENUBAR ) )
EndFunc


Func _makeMenu()
	$filemenu = GUICtrlCreateMenu($oLangStrings.menu.file.file)
	$applyitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.apply, $filemenu)
	GUICtrlSetOnEvent(-1, "_onApply")
	GUICtrlCreateMenuItem("", $filemenu)
	$renameitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.rename, $filemenu)
	GUICtrlSetOnEvent(-1, "_onRename")
	$newitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.new, $filemenu)
	GUICtrlSetOnEvent(-1, "_onNewItem")
	$saveitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.save, $filemenu)
	GUICtrlSetOnEvent(-1, "_onSave")
	$deleteitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.delete, $filemenu)
	GUICtrlSetOnEvent(-1, "_onDelete")
	$clearitem = GUICtrlCreateMenuItem($oLangStrings.menu.file.clear, $filemenu)
	GUICtrlSetOnEvent(-1, "_onClear")
	$createLinkItem = GUICtrlCreateMenuItem($oLangStrings.menu.file.shortcut, $filemenu)
	GUICtrlSetOnEvent(-1, "_onCreateLink")
	GUICtrlCreateMenuItem("", $filemenu) 	; create a separator line
	$profilesOpenItem = GUICtrlCreateMenuItem($oLangStrings.menu.file.open, $filemenu)
	GUICtrlSetOnEvent(-1, "_onOpenProfiles")
	$profilesImportItem = GUICtrlCreateMenuItem($oLangStrings.menu.file.import, $filemenu)
	GUICtrlSetOnEvent(-1, "_onImportProfiles")
	$profilesExportItem = GUICtrlCreateMenuItem($oLangStrings.menu.file.export, $filemenu)
	GUICtrlSetOnEvent(-1, "_onExportProfiles")
	GUICtrlCreateMenuItem("", $filemenu)
	$exititem = GUICtrlCreateMenuItem($oLangStrings.menu.file.exit, $filemenu)
	GUICtrlSetOnEvent(-1, "_onExit")

	$viewmenu = GUICtrlCreateMenu($oLangStrings.menu.view.view)
	$refreshitem = GUICtrlCreateMenuItem($oLangStrings.menu.view.refresh, $viewmenu)
	GUICtrlSetOnEvent(-1, "_onRefresh")
	$send2trayitem = GUICtrlCreateMenuItem($oLangStrings.menu.view.tray, $viewmenu)
	GUICtrlSetOnEvent(-1, "_onTray")
	GUICtrlCreateMenuItem("", $viewmenu) 	; create a separator line
	$blacklistitem = GUICtrlCreateMenuItem($oLangStrings.menu.view.hide, $viewmenu)
	GUICtrlSetOnEvent(-1, "_onBlacklist")

	$toolsmenu = GUICtrlCreateMenu($oLangStrings.menu.tools.tools)
	$pullitem = GUICtrlCreateMenuItem($oLangStrings.menu.tools.pull, $toolsmenu)
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
	$settingsitem = GUICtrlCreateMenuItem($oLangStrings.menu.tools.settings, $toolsmenu)
	GUICtrlSetOnEvent(-1, "_onSettings")

	$helpmenu = GUICtrlCreateMenu($oLangStrings.menu.help.help)
	$helpitem = GUICtrlCreateMenuItem($oLangStrings.menu.help.docs, $helpmenu)
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
	$LCaptionBorder = WinGetPos( $hGUI )
	;$captionHeight = $LCaptionBorder[3] - $guiheight
	$captionHeight = _WinAPI_GetSystemMetrics($SM_CYSIZE)
EndFunc

Func _makeCurrentProps($label, $x, $y, $w, $h)
	Local $aRet = _makeHeading($label, $x+1, $y+1, $w-2, -1, 0x0782FD, 0.95)
	$headingCurrent = $aRet[0]
	Local $headingHeight = $aRet[1]
	Local $bkcolor = 0xEEEEEE

	$label_CurrIp = GUICtrlCreateLabel( $oLangStrings.interface.props.ip & ":", $x+8*$dscale, $y+$headingHeight+8*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentIp = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+8*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrSubnet = GUICtrlCreateLabel( $oLangStrings.interface.props.subnet & ":", $x+8*$dscale, $y+$headingHeight+25*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentSubnet = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+25*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrGateway = GUICtrlCreateLabel( $oLangStrings.interface.props.gateway & ":", $x+8*$dscale, $y+$headingHeight+42*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentGateway = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+42*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_sep1 = GUICtrlCreateLabel( "", $x+1, $y+$headingHeight+62*$dscale, $w-2, 1)
;~ 	GUICtrlSetBkColor(-1, 0x0051FF)
	GUICtrlSetBkColor(-1, 0x404040)

	$label_CurrDnsPri = GUICtrlCreateLabel( $oLangStrings.interface.props.dnsPref & ":", $x+8*$dscale, $y+$headingHeight+67*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentDnsPri = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+67*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrDnsAlt = GUICtrlCreateLabel( $oLangStrings.interface.props.dnsAlt & ":", $x+8*$dscale, $y+$headingHeight+84*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentDnsAlt = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+84*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_sep2 = GUICtrlCreateLabel( "", $x+1, $y+$headingHeight+105*$dscale, $w-2, 1)
;~ 	GUICtrlSetBkColor(-1, 0x0051FF)
	GUICtrlSetBkColor(-1, 0x404040)

	$label_CurrDhcp = GUICtrlCreateLabel( $oLangStrings.interface.props.dhcpServer & ":", $x+8*$dscale, $y+$headingHeight+112*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentDhcp = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+112*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	$label_CurrAdapterState = GUICtrlCreateLabel( $oLangStrings.interface.props.adapterState & ":", $x+8*$dscale, $y+$headingHeight+129*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0x444444)
	$label_CurrentAdapterState = GUICtrlCreateInput( "000.000.000.000", $x+$w-125*$dscale-8*$dscale, $y+$headingHeight+129*$dscale, 125*$dscale, 15*$dscale, BITOR($ES_READONLY,$SS_CENTER), $WS_EX_TOOLWINDOW)
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, 0x444444)

	_makeBox($x, $y, $w, $h, $bkcolor)
EndFunc

Func _makeDnsProps($label, $x, $y, $w, $h)
	Local $aRet = _makeHeading($label, $x+1, $y+1, $w-2, 5, 0x0782FD, 0.95)
	Local $headingHeight = $aRet[1]
	GUIStartGroup()
	$radio_DnsAuto = GUICtrlCreateRadio( $oLangStrings.interface.props.dnsauto, $x+8*$dscale, $y+$headingHeight+4*$dscale, $w-16*$dscale, 20*$dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	$radio_DnsMan = GUICtrlCreateRadio( $oLangStrings.interface.props.dnsmanual, $x+8*$dscale, $y+$headingHeight+23*$dscale, $w-16*$dscale, 20*$dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	GUICtrlSetState(-1, $GUI_CHECKED)

	$label_DnsPri = GUICtrlCreateLabel( $oLangStrings.interface.props.dnsPref & ":", $x+8*$dscale, $y+$headingHeight+51*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_DnsPri = _GUICtrlIpAddress_Create( $hGUI, $x+$w-135*$dscale-8*$dscale, $y+$headingHeight+48*$dscale, 135*$dscale, 22*$dscale )
	_GUICtrlIpAddress_SetFontByHeight( $ip_DnsPri, $MyGlobalFontName, $MyGlobalFontHeight)

	$label_DnsAlt = GUICtrlCreateLabel( $oLangStrings.interface.props.dnsAlt & ":", $x+8*$dscale, $y+$headingHeight+77*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_DnsAlt = _GUICtrlIpAddress_Create( $hGUI, $x+$w-135*$dscale-8*$dscale, $y+$headingHeight+74*$dscale, 135*$dscale, 22*$dscale )
	_GUICtrlIpAddress_SetFontByHeight( $ip_DnsAlt, $MyGlobalFontName, $MyGlobalFontHeight)

	$ck_dnsReg = GUICtrlCreateCheckbox($oLangStrings.interface.props.dnsreg, $x+8*$dscale, $y+$h-19*$dscale, -1, 15*$dscale)
	GUICtrlSetBkColor(-1,0xFFFFFF)
	GUICtrlSetFont(-1, 8.5)

	_makeBox($x, $y, $w, $h)
EndFunc

Func _makeIpProps($label, $x, $y, $w, $h)
	Local $aRet = _makeHeading($label, $x+1, $y+1, $w-2, -1, 0x0782FD, 0.95)
	$headingIP = $aRet[0]
	Local $headingHeight = $aRet[1]
	GUIStartGroup()
	$radio_IpAuto = GUICtrlCreateRadio( $oLangStrings.interface.props.ipauto, $x+8*$dscale, $y+$headingHeight+4*$dscale, $w-16*$dscale, 20*$dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	$radio_IpMan = GUICtrlCreateRadio( $oLangStrings.interface.props.ipmanual, $x+8*$dscale, $y+$headingHeight+23*$dscale, $w-16*$dscale, 20*$dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetOnEvent(-1, "_onRadio")
	GUICtrlSetState(-1, $GUI_CHECKED)

	$label_ip = GUICtrlCreateLabel( $oLangStrings.interface.props.ip & ":", $x+8*$dscale, $y+$headingHeight+51*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_Ip = _GUICtrlIpAddress_Create( $hGUI, $x+$w-135*$dscale-8*$dscale, $y+$headingHeight+48*$dscale, 135*$dscale, 22*$dscale )
	_GUICtrlIpAddress_SetFontByHeight( $ip_Ip, $MyGlobalFontName, $MyGlobalFontHeight)

	$label_subnet = GUICtrlCreateLabel( $oLangStrings.interface.props.subnet & ":", $x+8*$dscale, $y+$headingHeight+77*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_Subnet = _GUICtrlIpAddress_Create( $hGUI, $x+$w-135*$dscale-8*$dscale, $y+$headingHeight+74*$dscale, 135*$dscale, 22*$dscale )
	_GUICtrlIpAddress_SetFontByHeight( $ip_Subnet, $MyGlobalFontName, $MyGlobalFontHeight)

	$label_gateway = GUICtrlCreateLabel( $oLangStrings.interface.props.gateway & ":", $x+8*$dscale, $y+$headingHeight+103*$dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$ip_Gateway = _GUICtrlIpAddress_Create( $hGUI, $x+$w-135*$dscale-8*$dscale, $y+$headingHeight+100*$dscale, 135*$dscale, 22*$dscale	)
	_GUICtrlIpAddress_SetFontByHeight( $ip_Gateway, $MyGlobalFontName, $MyGlobalFontHeight)

	_makeBox($x, $y, $w, $h)
EndFunc

Func _makeProfileSelect($label, $x, $y, $w, $h)
	Local $aRet = _makeHeading($label, $x+1, $y+1, $w-2, -1, 0x0782FD, 0.95)
	$headingProfiles = $aRet[0]
	Local $headingHeight = $aRet[1]
	$searchgraphic = GUICtrlCreatePic("", $x+5, $y+$headingHeight+3+2*$dscale, 16, 16)
	;_ResourceSetImageToCtrl($hGUI, $searchgraphic, "search_png")
	_memoryToPic($searchgraphic, GetIconData($pngSearch))

	$input_filter = GUICtrlCreateInput( "*", $x+12+11, $y+$headingHeight+3+2*$dscale, $w-12-18, 15*$dscale, -1, $WS_EX_TOOLWINDOW)
	GUICtrlCreateLabel( "", $x+3, $y+$headingHeight+3, $w-6, 20*$dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF	)
	GUICtrlCreateLabel( "", $x+2, $y+$headingHeight+2, $w-4, 20*$dscale+2)
	GUICtrlSetBkColor(-1, 0x777777	)
	$filter_dummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent($filter_dummy, "_onFilter")

	$list_profiles = GUICtrlCreateListView( $label, $x+1, $y+$headingHeight+2+20*$dscale+3, $w-2, $h-$headingHeight-3-20*$dscale-3-1, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOCOLUMNHEADER, $LVS_EDITLABELS), $WS_EX_TRANSPARENT)
	_GUICtrlListView_SetColumnWidth($list_profiles, 0, $w-2-20*$dscale)		; sets column width
	_GUICtrlListView_AddItem($list_profiles, "Item1")
	GUICtrlSetOnEvent($list_profiles, "_onLvEnter")

	; ListView Context Menu
	$lvcontext = GUICtrlCreateContextMenu($list_profiles)
	$lvcon_rename = GUICtrlCreateMenuItem($oLangStrings.lvmenu.rename, $lvcontext)
	GUICtrlSetOnEvent( -1, "_onRename")
	$lvcon_delete = GUICtrlCreateMenuItem($oLangStrings.lvmenu.delete, $lvcontext)
	GUICtrlSetOnEvent( -1, "_onDelete")
	GUICtrlCreateMenuItem("", $lvcontext)
	$lvcon_arrAz = GUICtrlCreateMenuItem($oLangStrings.lvmenu.sortAsc, $lvcontext)
	GUICtrlSetOnEvent( -1, "_onArrangeAz")
	$lvcon_arrZa = GUICtrlCreateMenuItem($oLangStrings.lvmenu.sortDesc, $lvcontext)
	GUICtrlSetOnEvent( -1, "_onArrangeZa")
	GUICtrlCreateMenuItem("", $lvcontext)
	$lvcreateLinkItem = GUICtrlCreateMenuItem($oLangStrings.lvmenu.shortcut, $lvcontext)
	GUICtrlSetOnEvent(-1, "_onCreateLink")

	$dummyUp = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onLvUp")

	$dummyDown = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onLvDown")

	_makeBox($x, $y, $w, $h)
EndFunc

Func _makeComboSelect($label, $x, $y, $w, $h)
	Local $aRet = _makeHeading($label, $x+1, $y+1, $w-2, -1, 0x0782FD, 0.95)
	$headingSelect = $aRet[0]
	Local $headingHeight = $aRet[1]

	$combo_adapters = GUICtrlCreateCombo( "", $x+8*$dscale, $y + $headingHeight + 8*$dscale, $w-16*$dscale, -1, BitOR($CBS_DROPDOWNlist, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetOnEvent($combo_adapters, "_OnCombo")
	_setFont($combo_adapters, $MyGlobalFontSize)
	$lDescription = GUICtrlCreateLabel( $oLangStrings.interface.adapterDesc, $x+8*$dscale, $y + $headingHeight + 9*$dscale + 26*$dscale, $w-16*$dscale, -1, $SS_LEFTNOWORDWRAP	 )
	_setFont($lDescription, 8.5, $MyGlobalFontBKColor)
	$lMac = GUICtrlCreateLabel( $oLangStrings.interface.mac & ": ", $x+8*$dscale, $y + $headingHeight + 9*$dscale + 41*$dscale, $w-16*$dscale, -1, $SS_LEFTNOWORDWRAP	 )
	_setFont($lMac, 8.5, $MyGlobalFontBKColor)

	$combo_dummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_onCombo")

	_makeBox($x, $y, $w, $h)
EndFunc

Func _makeToolbar()
	$tb2_width = $tbarHeight*$dscale / 2 - 4*$dscale

	$hTool = GUICreate('', $guiWidth*$dscale-18*$dscale-6,$tbarHeight*$dscale-1, 0, 0, $WS_CHILD, 0, $hGUI)
	$hToolbar = _GUICtrlToolbar_Create($hTool, BitOR($BTNS_BUTTON, $BTNS_SHOWTEXT, $TBSTYLE_FLAT, $TBSTYLE_TOOLTIPS), $TBSTYLE_EX_DOUBLEBUFFER)
 	GUICtrlSetBkColor(-1,GUISetBkColor( 0x888889))
	$ToolbarIDs = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_OnToolbarButton")

	$hImageList = _GUIImageList_Create(24, 24, 5, 1, 5)
	_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon(GetIconData($pngAccept)))
	_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon(GetIconData($pngRefresh)))
	_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon(GetIconData($pngAdd)))
	_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon(GetIconData($pngSave)))
	_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon(GetIconData($pngDelete)))
	_GUIImageList_ReplaceIcon($hImageList, -1, _getMemoryAsIcon(GetIconData($pngEdit)))

	_GUICtrlToolbar_SetImageList($hToolbar, $hImageList)

	Local $aStringList[6]
	$aStringList[0] = _GUICtrlToolbar_AddString($hToolbar, $oLangStrings.toolbar.apply)
	$aStringList[1] = _GUICtrlToolbar_AddString($hToolbar, $oLangStrings.toolbar.refresh)
	$aStringList[2] = _GUICtrlToolbar_AddString($hToolbar, $oLangStrings.toolbar.new)
	$aStringList[3] = _GUICtrlToolbar_AddString($hToolbar, $oLangStrings.toolbar.save)
	$aStringList[4] = _GUICtrlToolbar_AddString($hToolbar, $oLangStrings.toolbar.delete)
	$aStringList[5] = _GUICtrlToolbar_AddString($hToolbar, $oLangStrings.toolbar.clear)

	$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_apply, 0, $aStringList[0])
	$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_refresh, 1, $aStringList[1])
	$bbutton = _GUICtrlToolbar_AddButtonSep($hToolbar, 5)
	$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_add, 2, $aStringList[2])
	$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_save, 3, $aStringList[3])
	$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_delete, 4, $aStringList[4])
	$bbutton = _GUICtrlToolbar_AddButtonSep($hToolbar, 5)
	$bbutton = _GUICtrlToolbar_AddButton($hToolbar, $tb_clear, 5, $aStringList[5])

	_GUICtrlToolbar_SetButtonWidth($hToolbar, 35*$dscale, 65*$dscale)
	_GUICtrlToolbar_SetMetrics($hToolbar, 0, 0, 1, 0)
	_GUICtrlToolbar_SetIndent($hToolbar, 1)

	_GUICtrlToolbar_SetButtonSize($hToolbar, $tbarHeight*$dscale-4*$dscale, 50*$dscale)
	;_SendMessage($hToolbar, $TB_AUTOSIZE)

	GUISwitch($hgui)

	$hTool2 = GUICreate('',18*$dscale+6,$tbarHeight*$dscale-1, $guiWidth*$dscale-18*$dscale-6, 0, $WS_CHILD, 0, $hGUI)
	$hToolbar2 = _GUICtrlToolbar_Create($hTool2, BitOR($BTNS_BUTTON, $BTNS_SHOWTEXT, $TBSTYLE_FLAT, $TBSTYLE_TOOLTIPS), $TBSTYLE_EX_DOUBLEBUFFER)
	GUICtrlSetBkColor(-1,GUISetBkColor( 0x888889))
	$Toolbar2IDs = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_OnToolbar2Button")

	$hImageList2 = _GUIImageList_Create(16, 16, 5, 1, 2)
	_GUIImageList_ReplaceIcon($hImageList2, -1,_getMemoryAsIcon(GetIconData($pngSettings)))
	_GUIImageList_ReplaceIcon($hImageList2, -1, _getMemoryAsIcon(GetIconData($pngTray)))

	_GUICtrlToolbar_SetImageList($hToolbar2, $hImageList2)

	_GUICtrlToolbar_SetButtonSize($hToolbar2, 18*$dscale, 18*$dscale)

	$bbutton = _GUICtrlToolbar_AddButton($hToolbar2, $tb_settings, 0, 0)
	$bbutton = _GUICtrlToolbar_AddButton($hToolbar2, $tb_tray, 1, 1)

	_GUICtrlToolbar_SetRows($hToolbar2, 2)


	GUISwitch($hgui)

	GUICtrlCreateLabel('', 0, $tbarHeight*$dscale, $guiWidth*$dscale, 1)
	GUICtrlSetBkColor(-1, 0x101010)
EndFunc

; Create Header
Func _makeHeading($sLabel, $x, $y, $w, $height=-1, $color=-1, $lightness=-1)
	$strSize = _StringSize($sLabel, 8.5,  400, 0 , "Segoe UI")
	$labelX = ($w-$strSize[2]*$dscale)/2 + $x
	$h = $strSize[3]-2
	if $height <> -1 Then
		$h = $height
	EndIf
	$labelY = $y

	Local $heading = GUICtrlCreateLabel( $sLabel, $labelX, $labelY )
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
	$baseHSL = _ColorConvertRGBtoHSL ($baseRGB)
	$newL = $lightFactor * $baseHSL[2]
	If $newL < 0 Then $newL = 0
	Local $darkenHSL[3] = [$baseHSL[0], $baseHSL[1], $newL]
	$darkenRGB = _ColorConvertHSLtoRGB ($darkenHSL)
	$darkenColor = _ColorSetRGB ($darkenRGB)

	Local $aVertex[6][3] = [[0,0, $baseColor], [$w, $h, $darkenColor], [0,0, $baseColor], [$w, $h-$h/4, $darkenColor], [0, $h-$h/4, $darkenColor], [$w,$h, $baseColor]]
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
EndFunc

; Create Section Box
Func _makeBox($x, $y, $w, $h, $bkcolor=0xFFFFFF)
	Local $bg = GUICtrlCreateLabel( "", $x+1, $y+1, $w-2, $h-2 )
	GUICtrlSetBkColor(-1, $bkcolor)

	Local $border = GUICtrlCreateLabel( "", $x, $y, $w, $h	)
;~ 	GUICtrlSetBkColor(-1, 0x000880)
	GUICtrlSetBkColor(-1, 0x003973)
EndFunc
#EndRegion

#Region -- Helper Functions --
Func _memoryToPic($idPic, $name)
	$hBmp = _GDIPlus_BitmapCreateFromMemory(Binary($name),1)
	_WinAPI_DeleteObject(GUICtrlSendMsg($idPic, 0x0172, 0, $hBmp))
	_WinAPI_DeleteObject($hBmp)
	Return 0
EndFunc

Func _getMemoryAsIcon($name)
	$Bmp = _GDIPlus_BitmapCreateFromMemory(Binary($name))
	$hIcon = _GDIPlus_HICONCreateFromBitmap($Bmp)
	_GDIPlus_ImageDispose($Bmp)
	Return $hIcon
EndFunc

Func _setFont($ControlID, $size, $bkcolor=-1, $color=0x000000)
	Local $LControlID
	If $ControlID = -1 Then
		$LControlID = _GUIGetLastCtrlID()
	Else
		$LControlID = $ControlID
	EndIf
	GUICtrlSetFont( $LControlID, $size)
	GUICtrlSetColor( -1, $color )
	If $bkcolor <> -1 Then
		GUICtrlSetBkColor( -1, $bkcolor  )
	EndIf
EndFunc

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
EndFunc   ;==>_GUICtrlIpAddress_SetFont

Func _GUIGetLastCtrlID()
    Local $aRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", GUICtrlGetHandle(-1))
    Return $aRet[0]
EndFunc

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
EndFunc
#EndRegion

#Region -- ABOUT WINDOW --
; ABOUT WINDOW
Func _about()
	Local $bt_AboutOk, $lb_Heading, $lb_date, $lb_version, $lb_info, $lb_sig, $pic, $lb_license, $GFLine
	$w = 275 * $dScale
	$h = 230 * $dScale

	If NOT BITAND(WinGetState($hgui), $WIN_STATE_MINIMIZED) Then
		$currentWinPos = WinGetPos($hgui)
		$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
		$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2
	Else
		$x = @DesktopWidth / 2 - $w / 2
		$y = @DesktopHeight / 2 - $h / 2
	EndIf

	$AboutChild = GUICreate("About Simple IP Config", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	; top section

	GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	$pic = GUICtrlCreatePic("", 17 * $dScale, 22 * $dScale, 64, 64)
	_memoryToPic($pic, GetIconData($pngBigicon))

	GUICtrlCreateLabel("Simple IP Config", 75 * $dscale, 10 * $dscale, 200 * $dscale, -1, $SS_CENTER)
	GUICtrlSetFont(-1, 13, 800)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel("Version:", 95 * $dscale, 38 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel("Date:", 95 * $dscale, 53 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel("Developer:", 95 * $dscale, 69 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($winVersion, 174 * $dscale, 38 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($winDate, 174 * $dscale, 53 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel("Kurtis Liggett", 174 * $dscale, 69 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)


	GUICtrlCreateLabel("License:", 95 * $dscale, 84 * $dscale, 75 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel("GNU GPL v3", 174 * $dscale, 84 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)


	$desc = "The portable ip changer utility that allows a user to quickly and easily change the most common network settings for any connection."
	GUICtrlCreateLabel($desc, 8, 110 * $dscale, $w - 16, 50 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	GUICtrlCreateLabel("", 0, 165 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	;$link = _GUICtrlHyperLink_Create("Aha-Soft", 180 * $dscale, 175 * $dscale, -1, 20 * $dscale, 0x0000FF, 0x551A8B, -1, 'http://www.aha-soft.com/', 'Visit: aha-soft.com', $AboutChild)
	$link = GUICtrlCreateLabel("Aha-Soft", 180 * $dscale, 175 * $dscale, -1, 20 * $dscale)
	GUICtrlSetOnEvent(-1, "_iconLink")
	GUICtrlSetColor(-1,0x0000FF)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, -1, -1, $GUI_FONTUNDER)
	GUICtrlSetTip(-1, 'Visit: aha-soft.com')
	GUICtrlSetCursor(-1, 0)

	$desc = "Program icons are from "
	GUICtrlCreateLabel($desc, 45 * $dscale, 175 * $dscale, $w - 20, 20 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	; bottom section

	$bt_AboutOk = GUICtrlCreateButton("OK", $w - 55 * $dScale, $h - 27 * $dScale, 50 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent(-1, "_onExitChild")

	GUISetState(@SW_DISABLE, $hgui)
	GUISetState(@SW_SHOW, $AboutChild)
EndFunc
#EndRegion

#Region -- CHANGELOG WINDOW --
; Changelog WINDOW
Func _changeLog()
	$w = 305*$dScale
	$h = 410*$dScale

	$currentWinPos = WinGetPos($hgui)
	$x = $currentWinPos[0] + $guiWidth*$dscale/2 - $w/2
	$y = $currentWinPos[1] + $guiHeight*$dscale/2 - $h/2

	$changeLogChild = GUICreate( "Change Log", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent( $GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont ( $MyGlobalFontSize, -1, -1, $MyGlobalFontName )

	GUICtrlCreateLabel("", 0, 0, $w, $h-32*$dscale)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel("", 0, $h-32*$dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	Local $sChangelog = GetChangeLogData()
	$labelTitle = GUICtrlCreateLabel($sChangelog[0], 5, 5, $w-10, 20*$dscale)
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetBkColor (-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 11)

	$edit = GUICtrlCreateEdit($sChangelog[1], 5, 25, $w-10, $h-37*$dscale-25, BitOR($ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL), $WS_EX_TRANSPARENT)
	GUICtrlSetBkColor ($edit, 0xFFFFFF)
	GUICtrlSetFont(-1, 8.5)

	$bt_Ok = GUICtrlCreateButton( "OK", $w-55*$dScale, $h - 27*$dScale, 50*$dScale, 22*$dScale)
	GUICtrlSetOnEvent( -1, "_onExitChild")

	GUISetState(@SW_DISABLE, $hGUI)
	GUISetState(@SW_SHOW, $changeLogChild)

	Send("^{HOME}")
EndFunc
#EndRegion

#Region -- DEBUG WINDOW --
; debug WINDOW
Func _debugWindow()
	$w = 305*$dScale
	$h = 410*$dScale

	$currentWinPos = WinGetPos($hgui)
	$x = $currentWinPos[0] + $guiWidth*$dscale/2 - $w/2
	$y = $currentWinPos[1] + $guiHeight*$dscale/2 - $h/2

	$debugChild = GUICreate( "Debug Information", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent( $GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont ( $MyGlobalFontSize, -1, -1, $MyGlobalFontName )

	GUICtrlCreateLabel("", 0, 0, $w, $h-32*$dscale)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel("", 0, $h-32*$dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	$debuginfo = ""
	$debuginfo &= "OS Version:" & @TAB & @OSVersion & @CRLF
	$debuginfo &= "OS Service Pack:" & @TAB & @OSServicePack & @CRLF
	$debuginfo &= "OS Build:" & @TAB & @TAB & @OSBuild & @CRLF
	$debuginfo &= "OS Lang Code:" & @TAB & @OSLang & @CRLF
	$debuginfo &= "OS Architecture:" & @TAB & @OSArch & @CRLF
	$debuginfo &= "CPU Architecture:" & @TAB & @CPUArch & @CRLF
	$debuginfo &= "Resolution:" & @TAB & _WinAPI_GetSystemMetrics($SM_CXSCREEN) & "x" & _WinAPI_GetSystemMetrics($SM_CYSCREEN) & @CRLF
	$debuginfo &= "DPI:" & @TAB & @TAB & $iDPI & @CRLF

	$edit = GUICtrlCreateEdit($debuginfo, 5, 5, $w-10, $h-37*$dscale-5, BitOR($ES_READONLY, $WS_VSCROLL, $ES_AUTOVSCROLL), $WS_EX_TRANSPARENT)
	GUICtrlSetBkColor ($edit, 0xFFFFFF)
	GUICtrlSetFont(-1, 8.5)

	$bt_Ok = GUICtrlCreateButton( "OK", $w-55*$dScale, $h - 27*$dScale, 50*$dScale, 22*$dScale)
	GUICtrlSetOnEvent( -1, "_onExitChild")

	GUISetState(@SW_DISABLE, $hGUI)
	GUISetState(@SW_SHOW, $debugChild)

	Send("^{HOME}")
EndFunc
#EndRegion

#Region -- SETTINGS WINDOW --
; Settings WINDOW
Func _Settings()
	$w = 210*$dScale
	$h = 200*$dScale

	$currentWinPos = WinGetPos($hgui)
	$x = $currentWinPos[0] + $guiWidth*$dscale/2 - $w/2
	$y = $currentWinPos[1] + $guiHeight*$dscale/2 - $h/2

	$settingsChild = GUICreate( "Settings", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent( $GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont ( $MyGlobalFontSize, -1, -1, $MyGlobalFontName )

	GUICtrlCreateLabel("", 0, 0, $w, $h-32*$dscale)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel("", 0, $h-32*$dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	$lb_language = GUICtrlCreateLabel( "Language", 10*$dScale, 10*$dScale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	$cmb_langSelect = GUICtrlCreateCombo( "English", 10*$dScale, 28*$dScale, $w-20*$dScale, -1, BitOR($CBS_DROPDOWNlist, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetData(-1, "Italiano")

	$ck_startinTray = GUICtrlCreateCheckbox( "Startup in the system tray", 10*$dScale, 60*$dScale, 230*$dScale, 20*$dScale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState($ck_startinTray, _StrToState(Options_GetValue($options, $OPTIONS_StartupMode)))
	$ck_mintoTray = GUICtrlCreateCheckbox( "Minimize to the system tray", 10*$dScale, 80*$dScale, 230*$dScale, 20*$dScale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState($ck_mintoTray, _StrToState(Options_GetValue($options, $OPTIONS_MinToTray)))
	$ck_saveAdapter = GUICtrlCreateCheckbox( "Save adapter to profile", 10*$dScale, 100*$dScale, 230*$dScale, 20*$dScale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState($ck_saveAdapter, _StrToState(Options_GetValue($options, $OPTIONS_SaveAdapterToProfile)))

	$ck_autoUpdate = GUICtrlCreateCheckbox( "Automatically check for updates", 10*$dScale, 120*$dScale, 230*$dScale, 20*$dScale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState($ck_autoUpdate, _StrToState(Options_GetValue($options, $OPTIONS_AutoUpdate)))

	$bt_optSave = GUICtrlCreateButton( "Save", $w-25*$dScale-50*$dScale, $h - 27*$dScale, 50*$dScale, 22*$dScale)
	GUICtrlSetOnEvent( $bt_optSave, "_saveOptions")
	$bt_optCancel = GUICtrlCreateButton( "Cancel", 25*$dScale, $h - 27*$dScale, 50*$dScale, 22*$dScale)
	GUICtrlSetOnEvent( $bt_optCancel, "_onExitChild")

	GUISetState(@SW_DISABLE, $hGUI)
	GUISetState(@SW_SHOW, $settingsChild)
EndFunc
#EndRegion

#Region -- STATUS WINDOW --
; Status Message Popup
Func _statusPopup()
	$wPos = WinGetPos($hgui)

;~ 	$w = $guiWidth*$dScale
;~ 	$h = 250*$dScale
;~ 	$x = $wPos[0] + ($wPos[2]-$w)/2
;~ 	$y = $wPos[1] + $menuHeight + $guiheight*$dscale-$h + 1

	$w = $guiWidth*$dScale
	$h = 63*$dScale
	$x = 0
	$y = $guiheight*$dscale-$h-$menuHeight

	$statusChild = GUICreate( "StatusMessage", $w, $h, $x, $y, $WS_POPUP, $WS_EX_TOOLWINDOW)
	_WinAPI_SetParent($statusChild, $hGUI)
	GUISetOnEvent( $GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont ( $MyGlobalFontSize, -1, -1, $MyGlobalFontName )
	GUISetBkColor(_WinAPI_GetSysColor($COLOR_MENUBAR),$statusChild)

	$edit = GUICtrlCreateEdit( GUICtrlRead($statuserror), 5, 8, $w-10, $h-37*$dscale, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_NOHIDESEL, $ES_READONLY ), $WS_EX_TRANSPARENT )
	GUICtrlSetFont(-1, 8.5)
	Send("^{HOME}")

	GUICtrlCreateLabel ( "", 0, 1, $w, 1)
	GUICtrlSetBkColor (-1, 0xFFFFFF)

	GUICtrlCreateLabel ( "", 0, 0, $w, 1)
	GUICtrlSetBkColor (-1, 0x404040)

	$bt_Ok = GUICtrlCreateButton( "OK", $w-55*$dScale, $h - 27*$dScale, 50*$dScale, 22*$dScale)
	GUICtrlSetOnEvent( -1, "_onExitChild")

	;GUISetState(@SW_DISABLE, $hGUI)
	GUISetState(@SW_SHOW, $statusChild)

	;Switch to the parent window
    GUISwitch($hgui)
EndFunc
#EndRegion

#Region -- BLACKLIST WINDOW --
Func _blacklist()
	$sBlacklist = Options_GetValue($options, $OPTIONS_AdapterBlacklist)
	Local $aBlacklist = StringSplit( $sBlacklist, "|", 2)

	$w = 275*$dScale
	$h = 300*$dScale

	$currentWinPos = WinGetPos($hgui)
	$x = $currentWinPos[0] + $guiWidth*$dscale/2 - $w/2
	$y = $currentWinPos[1] + $guiHeight*$dscale/2 - $h/2

	$blacklistChild = GUICreate( "Adapter Blacklist", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetBkColor(0x888889)
	GUISetOnEvent( $GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont ( $MyGlobalFontSize, -1, -1, $MyGlobalFontName )

	$bkLabel = GUICtrlCreateLabel("", 0, 0, $w, $h-35*$dscale)
	GUICtrlSetBkColor($bkLabel, 0xFFFFFF)
	GUICtrlSetState($bkLabel, $GUI_DISABLE)

	$labelTitle = GUICtrlCreateLabel("Select Adapters to Hide", 5, 5, $w-10, 20*$dscale)
;~ 	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetBkColor (-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 12)

	$labelTitleLine = GUICtrlCreateLabel("", 2, 20*$dscale+5+3, $w-4, 1)
	GUICtrlSetBkColor (-1, 0x999999)

	$blacklistLV = GUICtrlCreateListView("Adapter Name", 5, 35*$dscale, $w-10, $h-35*$dscale-35*$dscale, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOCOLUMNHEADER), $LVS_EX_CHECKBOXES)
	GUICtrlSetBkColor ($blacklistLV, 0xFFFFFF)
	_GUICtrlListView_SetColumnWidth($blacklistLV, 0, $w-20*$dscale)		; sets column width
	Local $aAdapters = Adapter_GetNames($adapters)
	$numAdapters = UBound($aAdapters)
	if $numAdapters > 0 Then
		For $i=0 to $numAdapters-1
			GUICtrlCreateListViewItem($aAdapters[$i], $blacklistLV)
			If _ArraySearch($aBlacklist, $aAdapters[$i]) <> -1 Then
				_GUICtrlListView_SetItemChecked($blacklistLV, $i)
			EndIf
		Next
	EndIf

	$labelBottomLine = GUICtrlCreateLabel("", 0, $h-35*$dscale+1, $w, 1)
	GUICtrlSetBkColor (-1, 0x444444)

	$bt_Cancel = GUICtrlCreateButton( "Cancel", $w-117*$dScale, $h - 30*$dScale, 52*$dScale, 25*$dScale)
	GUICtrlSetOnEvent( -1, "_onExitChild")

	$bt_Ok = GUICtrlCreateButton( "Save", $w-60*$dScale, $h - 30*$dScale, 50*$dScale, 25*$dScale)
	GUICtrlSetOnEvent( -1, "_onExitBlacklistOk")

	GUICtrlSetState($bt_Cancel, $GUI_FOCUS)

	GUISetState(@SW_DISABLE, $hGUI)
	GUISetState(@SW_SHOW, $blacklistChild)

	Send("{END}")
EndFunc
#EndRegion

#Region -- UPDATE WINDOW --
; UPDATE WINDOW
Func _ShowUpdateDialog($thisVersion, $currentVersion, $isNew=0)
	Local $bt_UpdateOk, $lb_Heading, $lb_date, $lb_version, $lb_info, $lb_sig, $pic, $lb_license, $GFLine
	$w = 275 * $dScale
	$h = 170 * $dScale

	If NOT BITAND(WinGetState($hgui), $WIN_STATE_MINIMIZED) Then
		$currentWinPos = WinGetPos($hgui)
		$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
		$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2
	Else
		$x = @DesktopWidth / 2 - $w / 2
		$y = @DesktopHeight / 2 - $h / 2
	EndIf

	$UpdateChild = GUICreate("Check for Updates", $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	; top section

	GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	$pic = GUICtrlCreatePic("", 17 * $dScale, 22 * $dScale, 64, 64)
	_memoryToPic($pic, GetIconData($pngBigicon))

	GUICtrlCreateLabel("Simple IP Config", 75 * $dscale, 10 * $dscale, 200 * $dscale, -1, $SS_CENTER)
	GUICtrlSetFont(-1, 13, 800)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel("Your Version:", 80 * $dscale, 38 * $dscale, 120 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel("Latest Version:", 80 * $dscale, 53 * $dscale, 120 * $dscale, -1, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($thisVersion, 205 * $dscale, 38 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel($currentVersion, 205 * $dscale, 53 * $dscale, 75 * $dscale, -1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	GUICtrlCreateLabel("", 0, 100 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	Local $descX
	If $isNew Then
		$desc = "A newer version is available"
		$descX = 45

		$link = GUICtrlCreateLabel("here", 199 * $dscale, 110 * $dscale, -1, 20 * $dscale)
		GUICtrlSetOnEvent(-1, "_updateLink")
		GUICtrlSetColor(-1,0x0000FF)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, -1, -1, $GUI_FONTUNDER)
		GUICtrlSetTip(-1, 'Visit: https://github.com/KurtisLiggett/Simple-IP-Config/releases/latest')
		GUICtrlSetCursor(-1, 0)
	Else
		$desc = "You have the latest version."
		$descX = 60
	EndIf
	GUICtrlCreateLabel($desc, $descX * $dscale, 110 * $dscale, $w - 20, 20 * $dscale)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	; bottom section
	$bt_UpdateOk = GUICtrlCreateButton("OK", $w - 55 * $dScale, $h - 27 * $dScale, 50 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent(-1, "_onExitChild")

	GUISetState(@SW_DISABLE, $hgui)
	GUISetState(@SW_SHOW, $UpdateChild)
EndFunc
#EndRegion
