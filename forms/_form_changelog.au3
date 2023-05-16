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

Func _form_changelog()
	$w = 400 * $dScale
	$h = 410 * $dScale

	$currentWinPos = WinGetPos($hgui)
	$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
	$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2

	$changeLogChild = GUICreate($oLangStrings.changelog.changelog, $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	Local $sChangelog = GetChangeLogData()

	Local $edit = _GUICtrlRichEdit_Create($changeLogChild, "", 5, 5, $w - 10, $h - 37 * $dscale - 10, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL, $ES_READONLY), 0)
	_GUICtrlRichEdit_SetText($edit, _changelog_getData())

	Local $bt_Ok = GUICtrlCreateButton($oLangStrings.buttonOK, $w - 55 * $dScale, $h - 27 * $dScale, 50 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent(-1, "_onExitChild")

	GUISetState(@SW_DISABLE, $hgui)
	GUISetState(@SW_SHOW, $changeLogChild)

;~ 	Send("^{HOME}")
EndFunc   ;==>_form_changelog


;------------------------------------------------------------------------------
; Title...........: _changelog_getData
; Description.....: Get the change log string data
;
; Parameters......:
; Return value....: change log string array
;------------------------------------------------------------------------------
Func _changelog_getData()
#Tidy_Off
;disable formatting here
	Local $sData

	$sData = _changelog_formatVersion($winVersion)
		$sData &= _changelog_formatHeading(0, "BUG FIXES:")
			$sData &= _changelog_formatItem("#178  Error running from shortcut.")
			$sData &= _changelog_formatItem("#186  Wrong adapter selected.")
			$sData &= _changelog_formatItem("Domain name not updated after selecting language.")
			$sData &= _changelog_formatItem("Miscellaneous DPI scaling bugs.")
		$sData &= _changelog_formatHeading(1, "NEW FEATURES:")
			$sData &= _changelog_formatItem('#118  Added memo field to store notes per profile.')
			$sData &= _changelog_formatItem("#171  Added ability to resize the window.")
			$sData &= _changelog_formatItem('#175  Added "Dark" mode under View->Appearance menu.')

	$sData &= _changelog_formatPrevVersion("2.9.7")
		$sData &= _changelog_formatHeading(0, "BUG FIXES:")
			$sData &= _changelog_formatItem("#141  Behavior when adapter does not exist.")
			$sData &= _changelog_formatItem("#157  Save profiles in portable directory (auto-detect).")
			$sData &= _changelog_formatItem("#166  Workgroup incorrect text.")
			$sData &= _changelog_formatItem("#167  Refresh button does nothing.")
			$sData &= _changelog_formatItem("#169  Error reading language file.")
		$sData &= _changelog_formatHeading(1, "NEW FEATURES:")
			$sData &= _changelog_formatItem("#123  Added copy/paste buttons to IP addresses.")
			$sData &= _changelog_formatItem("#163  Close to system tray.")
			$sData &= _changelog_formatItem("#164  Auto expand larger error popup messages.")

	$sData &= _changelog_formatPrevVersion("v2.9.6")
		$sData &= _changelog_formatHeading(0, "BUG FIXES:")
			$sData &= _changelog_formatItem("Internal issues with array handling. (affected lots of things).")
			$sData &= _changelog_formatItem("#152  Program antivirus false-positive.")

	$sData &= _changelog_formatPrevVersion("v2.9.5")
		$sData &= _changelog_formatHeading(0, "BUG FIXES:")
			$sData &= _changelog_formatItem("#150  Fixed issue - Sort profiles crashed and deleted all profiles.")
			$sData &= _changelog_formatItem("#148  Fixed issue - Apply button text language.")

	$sData &= _changelog_formatPrevVersion("v2.9.4")
		$sData &= _changelog_formatHeading(0, "BUG FIXES:")
			$sData &= _changelog_formatItem("#143  Fixed issue - crash on TAB key while renaming.")
			$sData &= _changelog_formatItem("#103  COM Error 80020009 checking for updates.")
			$sData &= _changelog_formatItem("Bug creating new profiles from scratch.")
		$sData &= _changelog_formatHeading(1, "NEW FEATURES:")
			$sData &= _changelog_formatItem("#117  Added multi-language support.")
			$sData &= _changelog_formatItem("#99  Added ability to open, import, and export profiles.")
			$sData &= _changelog_formatItem("Added menu item to open network connections.")
			$sData &= _changelog_formatItem("Added menu item to go to profiles.ini location.")
			$sData &= _changelog_formatItem("Select subnet when tabbing from IP.")
			$sData &= _changelog_formatItem("#43  Escape key will no longer close the program.")
			$sData &= _changelog_formatItem("#104  Bring to foreground if already running.")
		$sData &= _changelog_formatHeading(1, "MAINT:")
			$sData &= _changelog_formatItem("Updated layout.")
			$sData &= _changelog_formatItem("New toolbar icons.")
			$sData &= _changelog_formatItem("Updated check for updates functionality.")
			$sData &= _changelog_formatItem("Moved profiles.ini to local AppData")
			$sData &= _changelog_formatItem("Removed shortcut Ctrl+c to prevent accidental clear")
			$sData &= _changelog_formatItem("Code redesigned.")

	$sData &= _changelog_formatPrevVersion("v2.9.3")
		$sData &= _changelog_formatHeading(0, "BUG FIXES:")
			$sData &= _changelog_formatItem("#80  Bad automatic update behavior.")
		$sData &= _changelog_formatHeading(1, "NEW FEATURES:")
			$sData &= _changelog_formatItem("#80 Better update handling / new dialog.")

	$sData &= _changelog_formatPrevVersion("v2.9.2")
		$sData &= _changelog_formatHeading(0, "BUG FIXES:")
			$sData &= _changelog_formatItem("#75  After search, profiles don't load.")
		$sData &= _changelog_formatHeading(1, "NEW FEATURES:")
			$sData &= _changelog_formatItem("#36  Better hide adapters popup selection.")

	$sData &= _changelog_formatPrevVersion("v2.9.1")
		$sData &= _changelog_formatHeading(0, "BUG FIXES:")
			$sData &= _changelog_formatItem("#71  COM error when no internet connection.")

	$sData &= _changelog_formatPrevVersion("v2.9")
		$sData &= _changelog_formatHeading(0, "NEW FEATURES:")
			$sData &= _changelog_formatItem("#4  Create desktop shortcuts to profiles")
			$sData &= _changelog_formatItem("#15  Automatic Updates")
			$sData &= _changelog_formatItem("#7  Added Debug item to Help menu for troubleshooting issues.")
		$sData &= _changelog_formatHeading(1, "MAJOR CHANGES:")
			$sData &= _changelog_formatItem("Major code improvements")
		$sData &= _changelog_formatHeading(1, "BUG FIXES:")
			$sData &= _changelog_formatItem("#3  Setting profiles when profiles.ini is out of order.")
			$sData &= _changelog_formatItem("#3  Setting profiles after drag-and-drop to rearrange.")
			$sData &= _changelog_formatItem("#13  Issue opening the program two times.")
			$sData &= _changelog_formatItem("#19  Program starts off screen with dual screens.")
			$sData &= _changelog_formatItem("#22  Program crashes on Delete.")
			$sData &= _changelog_formatItem("#23  Profile '0' created unintentionally.")
			$sData &= _changelog_formatItem("#24  Double-clicking profiles behavior.")
			$sData &= _changelog_formatItem("#25  Adapters not showing up with underscore.")
			$sData &= _changelog_formatItem("#26  Left-handed mouse could not select profiles.")
			$sData &= _changelog_formatItem("#35  Hide adapters broken.")
			$sData &= _changelog_formatItem("#39/40  Sort profiles broken.")
			$sData &= _changelog_formatItem("#42  Issue with checking for updates.")
			$sData &= _changelog_formatItem("#44  Help menu link to documentation.")
			$sData &= _changelog_formatItem("#45  Added menu mnemonics (access keys).")
			$sData &= _changelog_formatItem("#47  Fixed message on duplicate IP address.")

	$sData &= _changelog_formatPrevVersion("v2.8.1")
		$sData &= _changelog_formatHeading(0, "BUG FIXES:")
			$sData &= _changelog_formatItem("IP address entry text scaling")

	$sData &= _changelog_formatPrevVersion("v2.8")
		$sData &= _changelog_formatHeading(0, "MAJOR CHANGES:")
			$sData &= _changelog_formatItem("Now using IP Helper API (Iphlpapi.dll) instead of WMI")
			$sData &= _changelog_formatItem("Speed improvements -> 2x faster!")
		$sData &= _changelog_formatHeading(1, "MINOR CHANGES:")
			$sData &= _changelog_formatItem("Automatically fill in 255.255.255.0 for subnet")
			$sData &= _changelog_formatItem("Save last window position on exit")
			$sData &= _changelog_formatItem("Tray message when an trying to start a new instance")
			$sData &= _changelog_formatItem("Smaller exe file size")
			$sData &= _changelog_formatItem("Popup window positioning follows main window")
			$sData &= _changelog_formatItem("Allow more space for current properties")
			$sData &= _changelog_formatItem("Smoother startup process")
			$sData &= _changelog_formatItem("Get current information from disconnected adapters")
		$sData &= _changelog_formatHeading(1, "BUG FIXES:")
			$sData &= _changelog_formatItem("IP address entry text scaling")
			$sData &= _changelog_formatItem("Fixed 'start in system tray' setting")
			$sData &= _changelog_formatItem("Fixed starting without toolbar icons")
			$sData &= _changelog_formatItem("Display disabled adapters")
			$sData &= _changelog_formatItem("Get current properties from disabled adapters")
			$sData &= _changelog_formatItem("Disabled adapters behavior")
			$sData &= _changelog_formatItem("Fixed hanging on setting profiles")
			$sData &= _changelog_formatItem("Fixed renaming/creating profiles issues")
			$sData &= _changelog_formatItem("Fixed additional DPI scaling issues")

	$sData &= _changelog_formatPrevVersion("v2.7")
		$sData &= _changelog_formatHeading(0, "MAJOR CHANGES:")
			$sData &= _changelog_formatItem("Code switched back to AutoIt")
			$sData &= _changelog_formatItem("Proper DPI scaling")
		$sData &= _changelog_formatHeading(1, "NEW FEATURES:")
			$sData &= _changelog_formatItem("Enable DNS address registration")
			$sData &= _changelog_formatItem("Hide unused adapters" & "(View->Hide adapters)")
			$sData &= _changelog_formatItem("Display computer name and domain address")
		$sData &= _changelog_formatHeading(1, "OTHER CHANGES:")
			$sData &= _changelog_formatItem("Single click to restore from system tray")
			$sData &= _changelog_formatItem("Improved status bar")
			$sData &= _changelog_formatItem("Allow only 1 instance to run")
		$sData &= _changelog_formatHeading(1, "BUG FIXES:")
			$sData &= _changelog_formatItem("Proper scaling with larger/smaller screen fonts")
			$sData &= _changelog_formatItem("Fixed tooltip in system tray")

	$sData &= _changelog_formatPrevVersion("v2.6")
		$sData &= _changelog_formatHeading(0, "NEW FEATURES:")
			$sData &= _changelog_formatItem("Filter Profiles!")
			$sData &= _changelog_formatItem("'Start in System Tray' setting")
			$sData &= _changelog_formatItem("Release / renew DHCP tool")
			$sData &= _changelog_formatItem("'Saveas' button is now 'New' button")
		$sData &= _changelog_formatHeading(1, "OTHER CHANGES:")
			$sData &= _changelog_formatItem("Enhanced 'Rename' interface")
			$sData &= _changelog_formatItem("New layout to show more profiles")
			$sData &= _changelog_formatItem("Other GUI enhancements")
		$sData &= _changelog_formatHeading(1, "BUG FIXES:")
			$sData &= _changelog_formatItem("Detect no IP address / subnet input")
			$sData &= _changelog_formatItem("Fix DNS error occurring on some systems")
			$sData &= _changelog_formatItem("Better detection of duplicate profile names")

	$sData &= "\line}"

	Return $sData
#Tidy_On
EndFunc   ;==>_changelog_getData

Func _changelog_formatVersion($sText)
	Local $data = "" & _
			"{\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1033{\fonttbl{\f0\fnil\fcharset0 Calibri;}{\f1\fnil\fcharset2 Symbol;}}" & @CRLF & _
			"{\colortbl ;\red0\green77\blue187;\red63\green63\blue63;}" & @CRLF & _
			"{\*\generator Riched20 10.0.19041}\viewkind4\uc1 " & @CRLF & _
			"\pard\sl240\slmult1\cf1\b\f0\fs36\lang9 " & $sText & "\par" & @CRLF & _
			"\cf0\b0\fs22\par" & @CRLF

	Return $data
EndFunc   ;==>_changelog_formatVersion

Func _changelog_formatPrevVersion($sText)
	Local $data = "" & _
			"\pard\sl240\slmult1\cf2\fs22 ____________________________________________________\line\line\b\fs24 " & $sText & "\par" & @CRLF & _
			"\b0\fs22\par" & @CRLF

	Return $data
EndFunc   ;==>_changelog_formatPrevVersion

Func _changelog_formatHeading($bAdd, $sText)
	Local $data = ""

	If $bAdd Then
		$data &= "\pard\sl240\slmult1\par" & @CRLF
	EndIf

	$data &= "\cf2\b " & $sText & "\par" & @CRLF

	Return $data
EndFunc   ;==>_changelog_formatHeading

Func _changelog_formatItem($sText)
	Local $data = "" & _
			"\pard{\pntext\f1\'B7\tab}{\*\pn\pnlvlblt\pnf1\pnindent0{\pntxtb\'B7}}\fi-180\li360\sl240\slmult1\b0\fs20 " & $sText & "\par" & @CRLF

	Return $data
EndFunc   ;==>_changelog_formatItem



;------------------------------------------------------------------------------
; Title...........: GetChangeLogData
; Description.....: Get the change log string data
;
; Parameters......:
; Return value....: change log string array
;------------------------------------------------------------------------------
Func GetChangeLogData()
	Local $sChangelog[2]
	;"v"&$winVersion & @CRLF & _
	$sChangelog[0] = $oLangStrings.changelog.changelog & " - " & $winVersion
	$sChangelog[1] = @CRLF & _
			"BUG FIXES:" & @CRLF & _
			"     #178   Error running from shortcut." & @CRLF & _
			"     #186   Wrong adapter selected." & @CRLF & _
			"                Domain name not updated after selecting language." & @CRLF & _
			"                Miscellaneous DPI scaling bugs." & @CRLF & _
			"NEW FEATURES:" & @CRLF & _
			'     #171   Added ability to resize the main window.' & @CRLF & _
			'     #175   Added "Dark" mode under View->Appearance menu.' & @CRLF & _
			'____________________________________________________' & @CRLF & _
			@CRLF & _
			"v2.9.7" & @CRLF & _
			"BUG FIXES:" & @CRLF & _
			"     #141   Behavior when adapter does not exist." & @CRLF & _
			"     #157   Save profiles in portable directory (auto-detect)." & @CRLF & _
			"     #166   Workgroup incorrect text." & @CRLF & _
			"     #167   Refresh button does nothing." & @CRLF & _
			"     #169   Error reading language file." & @CRLF & _
			"NEW FEATURES:" & @CRLF & _
			"     #123   Added copy/paste buttons to IP addresses." & @CRLF & _
			"     #163   Close to system tray." & @CRLF & _
			"     #164   Auto expand larger error popup messages." & @CRLF & _
			@CRLF & _
			"v2.9.6" & @CRLF & _
			"BUG FIXES:" & @CRLF & _
			"     Internal issues with array handling. (affected lots of things)." & @CRLF & _
			"     #152   Program antivirus false-positive." & @CRLF & _
			@CRLF & _
			"v2.9.5" & @CRLF & _
			"BUG FIXES:" & @CRLF & _
			"     #150   Fixed issue - Sort profiles crashed and deleted all profiles." & @CRLF & _
			"     #148   Fixed issue - Apply button text language." & @CRLF & _
			@CRLF & _
			"v2.9.4" & @CRLF & _
			"BUG FIXES:" & @CRLF & _
			"     #143   Fixed issue - crash on TAB key while renaming." & @CRLF & _
			"     #103   COM Error 80020009 checking for updates." & @CRLF & _
			"     Bug creating new profiles from scratch." & @CRLF & _
			"NEW FEATURES:" & @CRLF & _
			"     #117  Added multi-language support." & @CRLF & _
			"     #99   Added ability to open, import, and export profiles." & @CRLF & _
			"     Added menu item to open network connections." & @CRLF & _
			"     Added menu item to go to profiles.ini location." & @CRLF & _
			"     Select subnet when tabbing from IP." & @CRLF & _
			"     #43   Escape key will no longer close the program." & @CRLF & _
			"     #104   Bring to foreground if already running." & @CRLF & _
			"MAINT:" & @CRLF & _
			"     Updated layout." & @CRLF & _
			"     New toolbar icons." & @CRLF & _
			"     Updated check for updates functionality." & @CRLF & _
			"     Moved profiles.ini to local AppData" & @CRLF & _
			"     Removed shortcut Ctrl+c to prevent accidental clear" & @CRLF & _
			"     Code redesigned." & @CRLF & _
			@CRLF & _
			"v2.9.3" & @CRLF & _
			"BUG FIXES:" & @CRLF & _
			"   #80   Bad automatic update behavior." & @CRLF & _
			"NEW FEATURES:" & @CRLF & _
			"   #80   Better update handling / new dialog." & @CRLF & _
			@CRLF & _
			"v2.9.2" & @CRLF & _
			"BUG FIXES:" & @CRLF & _
			"   #75   After search, profiles don't load." & @CRLF & _
			"NEW FEATURES:" & @CRLF & _
			"   #36   Better hide adapters popup selection." & @CRLF & _
			@CRLF & _
			"v2.9.1" & @CRLF & _
			"BUG FIXES:" & @CRLF & _
			"   #71   COM error when no internet connection." & @CRLF & _
			@CRLF & _
			"v2.9" & @CRLF & _
			"NEW FEATURES:" & @CRLF & _
			"   #4   Create desktop shortcuts to profiles" & @CRLF & _
			"   #15  Automatic Updates" & @CRLF & _
			"   #7   Added Debug item to Help menu for troubleshooting issues." & @CRLF & _
			"MAJOR CHANGES:" & @CRLF & _
			"   Major code improvements" & @CRLF & _
			"BUG FIXES:" & @CRLF & _
			"   #3   Setting profiles when profiles.ini is out of order." & @CRLF & _
			"   #3   Setting profiles after drag-and-drop to rearrange." & @CRLF & _
			"   #13  Issue opening the program two times." & @CRLF & _
			"   #19  Program starts off screen with dual screens." & @CRLF & _
			"   #22  Program crashes on Delete." & @CRLF & _
			"   #23  Profile '0' created unintentionally." & @CRLF & _
			"   #24  Double-clicking profiles behavior." & @CRLF & _
			"   #25  Adapters not showing up with underscore." & @CRLF & _
			"   #26  Left-handed mouse could not select profiles." & @CRLF & _
			"   #35   	Hide adapters broken." & @CRLF & _
			"   #39/40  Sort profiles broken." & @CRLF & _
			"   #42   	Issue with checking for updates." & @CRLF & _
			"   #44   	Help menu link to documentation." & @CRLF & _
			"   #45   	Added menu mnemonics (access keys)." & @CRLF & _
			"   #47   	Fixed message on duplicate IP address." & @CRLF & _
			@CRLF & _
			"v2.8.1" & @CRLF & _
			"BUG FIXES:" & @CRLF & _
			"   IP address entry text scaling" & @CRLF & _
			@CRLF & _
			"v2.8" & @CRLF & _
			"MAJOR CHANGES:" & @CRLF & _
			"   Now using IP Helper API (Iphlpapi.dll) instead of WMI" & @CRLF & _
			"   Speed improvements -> 2x faster!" & @CRLF & _
			@CRLF & _
			"MINOR CHANGES:" & @CRLF & _
			"   Automatically fill in 255.255.255.0 for subnet" & @CRLF & _
			"   Save last window position on exit" & @CRLF & _
			"   Tray message when an trying to start a new instance" & @CRLF & _
			"   Smaller exe file size" & @CRLF & _
			"   Popup window positioning follows main window" & @CRLF & _
			"   Allow more space for current properties" & @CRLF & _
			"   Smoother startup process" & @CRLF & _
			"   Get current information from disconnected adapters" & @CRLF & _
			@CRLF & _
			"BUG FIXES:" & @CRLF & _
			"   IP address entry text scaling" & @CRLF & _
			"   Fixed 'start in system tray' setting" & @CRLF & _
			"   Fixed starting without toolbar icons" & @CRLF & _
			"   Display disabled adapters" & @CRLF & _
			"   Get current properties from disabled adapters" & @CRLF & _
			"   Disabled adapters behavior" & @CRLF & _
			"   Fixed hanging on setting profiles" & @CRLF & _
			"   Fixed renaming/creating profiles issues" & @CRLF & _
			"   Fixed additional DPI scaling issues" & @CRLF & _
			@CRLF & _
			"v2.7" & @CRLF & _
			"MAJOR CHANGES:" & @CRLF & _
			"   Code switched back to AutoIt" & @CRLF & _
			"   Proper DPI scaling" & @CRLF & _
			@CRLF & _
			"NEW FEATURES:" & @CRLF & _
			"   Enable DNS address registration" & @CRLF & _
			"   Hide unused adapters" & "(View->Hide adapters)" & @CRLF & _
			"   Display computer name and domain address" & @CRLF & _
			@CRLF & _
			"OTHER CHANGES:" & @CRLF & _
			"   Single click to restore from system tray" & @CRLF & _
			"   Improved status bar" & @CRLF & _
			"   Allow only 1 instance to run" & @CRLF & _
			@CRLF & _
			"BUG FIXES:" & @CRLF & _
			"   Proper scaling with larger/smaller screen fonts" & @CRLF & _
			"   Fixed tooltip in system tray" & @CRLF & _
			@CRLF & _
			"v2.6" & @CRLF & _
			"NEW FEATURES:" & @CRLF & _
			"   Filter Profiles!" & @CRLF & _
			"   'Start in System Tray' setting" & @CRLF & _
			"   Release / renew DHCP tool" & @CRLF & _
			"   'Saveas' button is now 'New' button" & @CRLF & _
			@CRLF & _
			"OTHER CHANGES:" & @CRLF & _
			"   Enhanced 'Rename' interface" & @CRLF & _
			"   New layout to show more profiles" & @CRLF & _
			"   Other GUI enhancements" & @CRLF & _
			@CRLF & _
			"BUG FIXES:" & @CRLF & _
			"   Detect no IP address / subnet input" & @CRLF & _
			"   Fix DNS error occurring on some systems" & @CRLF & _
			"   Better detection of duplicate profile names" & @CRLF

	Return $sChangelog
EndFunc   ;==>GetChangeLogData
