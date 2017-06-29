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

Global $screenshot=0

;Global Const $STM_SETIMAGE = 0x0172
;Global Const $STM_GETIMAGE = 0x0173
; GetWinState Constants
Global Const $WIN_STATE_EXISTS = 1 ; Window exists
Global Const $WIN_STATE_VISIBLE = 2 ; Window is visible
Global Const $WIN_STATE_ENABLED = 4 ; Window is enabled
Global Const $WIN_STATE_ACTIVE = 8 ; Window is active
Global Const $WIN_STATE_MINIMIZED = 16 ; Window is minimized
Global Const $WIN_STATE_MAXIMIZED = 32 ; Window is maximized

; GLOBAL DECLARATIONS
Global $winName = "Simple IP Config"
Global $winVersion = "2.8.1 b1"
Global $winDate = "06/24/2017"
Global $hgui
Global $guiWidth = 550
Global $guiHeight = 550
Global $footerHeight = 16
Global $tbarHeight = 49
Global $dscale = 1
Global $iDPI = 0
Global $AboutChild, $changeLogChild, $statusChild, $blacklistChild, $debugChild
Global $headingHeight = 20
Global $statusbarHeight = 20
Global $statustext, $statuserror, $sStatusMessage
Global $menuHeight, $captionHeight
Global $MinToTray, $RestoreItem
Global $toolsmenu, $disableitem, $refreshitem, $renameitem, $deleteitem, $clearitem, $saveitem, $newitem, $pullitem, $send2trayitem, $helpitem, $debugmenuitem
Global $tray_tip
Global $settingsChild, $ck_mintoTray, $ck_startinTray, $ck_saveAdapter
Global $aAccelKeys[12][2], $movetosubnet
Global $wgraphic, $showWarning
Global $images[1] = [0]

Global $iPID = -1, $pRuntime
Global $pRunning, $pDone, $sStdOut, $sStdErr, $pIdle=1
Global $pQueue[1][2]=[[0,0]]

Global $mdblTimerInit=0, $mdblTimerDiff=1000, $mdblcheck=0, $mdblClick = 0
Global $dragging = False, $dragitem = 0, $contextSelect = 0
Global $prevWinPos, $winPosTimer, $writePos

; Global Fonts
Global $MyGlobalFontName = "Arial"
Global $MyGlobalFontSize = 9.5
Global $MYGlobalFontSizeLarge = 11
Global $MyGlobalFontColor = 0x000000
Global $MyGlobalFontBKColor = $GUI_BKCOLOR_TRANSPARENT
Global $MyGlobalFontHeight = 0


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


; WMI
Global $objWMI
Global Const $wbemFlagReturnImmediately = 0x10
Global Const $wbemFlagForwardOnly = 0x20

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


Global $sChangeLog[2]
$sChangeLog[0] = "Changelog - " & $winVersion
$sChangeLog[1] = @CRLF & _
	"v"&$winVersion & @CRLF & _
	"BUG FIXES:" & @CRLF & _
	"   IP address entry text scaling" & @CRLF & _
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

