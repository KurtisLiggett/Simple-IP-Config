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


Global $g_ip_profile_editIp
Global $g_ip_profile_editSubnet
Global $g_editIP_profileWindow

Func _form_edit_ip_profile()
    $w = 180 * $dScale
    $h = 160 * $dScale

    $currentWinPos = WinGetPos($hgui)
    $x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
    $y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2

    $xIndent = 5 * $dscale
    $yText_offset = 10 * $dscale
    $textHeight = 16 * $dscale
    $textSpacer = 6 * $dscale

    ; Crea la finestra (usa $settingsChild globale)
    $settingsChild = GUICreate($oLangStrings.multiIP.editIP, $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
    GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
    GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	$g_editIPWindow_profile=$settingsChild ; Salva l'handle della finestra in una variabile globale per usarla in _onEditIPConfirm

    ; Sfondo
    GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
    GUICtrlSetState(-1, $GUI_DISABLE)
    GUICtrlSetBkColor(-1, 0xFFFFFF)

    GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
    GUICtrlSetBkColor(-1, 0x000000)

    ; IP address label
    $label_ip_edit = GUICtrlCreateLabel($oLangStrings.interface.props.ip & ":", 10 * $dScale, 10 * $dScale)
    GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
    
    ; IP address control - CORRETTO: usa $settingsChild come handle
     $ip_Ip_edit = _GUICtrlIpAddress_Create($settingsChild, 10 * $dScale, 30 * $dScale, 135 * $dscale, 22 * $dscale)
    _GUICtrlIpAddress_SetFontByHeight($ip_Ip_edit, $MyGlobalFontName, $MyGlobalFontHeight)
    
    _GUICtrlIpAddress_Set($ip_Ip_edit, $g_ip_profile_editIp)
    ; Subnet mask label
    $label_subnet_edit = GUICtrlCreateLabel($oLangStrings.interface.props.subnet & ":", 10 * $dScale, 60 * $dScale)
    GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
    
    ; Subnet mask control
    $ip_Subnet_edit = _GUICtrlIpAddress_Create($settingsChild, 10 * $dScale, 80 * $dScale, 135 * $dscale, 22 * $dscale)
    _GUICtrlIpAddress_SetFontByHeight($ip_Subnet_edit, $MyGlobalFontName, $MyGlobalFontHeight)
    
    ; Imposta subnet mask di default (255.255.255.0)
    _GUICtrlIpAddress_Set($ip_Subnet_edit, $g_ip_profile_editSubnet)
    
    ; Pulsante Add (OK)
    $bt_optAdd = GUICtrlCreateButton($oLangStrings.buttonSave, $w - 20 * $dScale - 75 * $dScale * 2 - 5, _
                     $h - 27 * $dScale, 75 * $dScale, 22 * $dScale)
    GUICtrlSetOnEvent($bt_optAdd, "_onEditIPConfirm_profile")
    
    ; Pulsante Cancel
    $bt_optCancel = GUICtrlCreateButton($oLangStrings.buttonCancel, $w - 20 * $dScale - 75 * $dScale, _
                     $h - 27 * $dScale, 75 * $dScale, 22 * $dScale)
    GUICtrlSetOnEvent($bt_optCancel, "_onExitAddIP_profile")

    ; Salva gli handle dei controlli in variabili globali per usarli in _onEditIPConfirm_profile
    $g_ip_profile_editIp = $ip_Ip_edit
    $g_ip_profile_editSubnet = $ip_Subnet_edit

    GUISetState(@SW_DISABLE, $hgui)
    GUISetState(@SW_SHOW, $settingsChild)
EndFunc