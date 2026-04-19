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

Global $g_editIP_Ip
Global $g_editIP_Subnet
Global $g_editIPWindow

Func _form_edit_ip($sCurrentIP, $sCurrentSubnet)
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

	$g_editIPWindow=$settingsChild ; Salva l'handle della finestra in una variabile globale per usarla in _onAddIPConfirm

    ; Sfondo
    GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
    GUICtrlSetState(-1, $GUI_DISABLE)
    GUICtrlSetBkColor(-1, 0xFFFFFF)

    GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
    GUICtrlSetBkColor(-1, 0x000000)

    ; IP address label
    $label_ip = GUICtrlCreateLabel($oLangStrings.interface.props.ip & ":", 10 * $dScale, 10 * $dScale)
    GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
    
    ; IP address control - CORRETTO: usa $settingsChild come handle
    $g_editIP_Ip = _GUICtrlIpAddress_Create($settingsChild, 10 * $dScale, 30 * $dScale, 135 * $dscale, 22 * $dscale)
    _GUICtrlIpAddress_SetFontByHeight($g_editIP_Ip, $MyGlobalFontName, $MyGlobalFontHeight)
    
    ; Subnet mask label
    $label_subnet = GUICtrlCreateLabel($oLangStrings.interface.props.subnet & ":", 10 * $dScale, 60 * $dScale)
    GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
    
    ; Subnet mask control
    $g_editIP_Subnet = _GUICtrlIpAddress_Create($settingsChild, 10 * $dScale, 80 * $dScale, 135 * $dscale, 22 * $dscale)
    _GUICtrlIpAddress_SetFontByHeight($g_editIP_Subnet, $MyGlobalFontName, $MyGlobalFontHeight)
    
    ; Imposta ip e subnet mask correnti
    _GUICtrlIpAddress_Set($g_editIP_Ip, $sCurrentIP) 
    _GUICtrlIpAddress_Set($g_editIP_Subnet, $sCurrentSubnet)
    
    ; Pulsante Edit (OK)
    $bt_optAdd = GUICtrlCreateButton($oLangStrings.buttonSave, $w - 20 * $dScale - 75 * $dScale * 2 - 5, _
                     $h - 27 * $dScale, 75 * $dScale, 22 * $dScale)
    GUICtrlSetOnEvent($bt_optAdd, "_onEditIPConfirm")
    
    ; Pulsante Cancel
    $bt_optCancel = GUICtrlCreateButton($oLangStrings.buttonCancel, $w - 20 * $dScale - 75 * $dScale, _
                     $h - 27 * $dScale, 75 * $dScale, 22 * $dScale)
    GUICtrlSetOnEvent($bt_optCancel, "_onExitAddIP")


    GUISetState(@SW_DISABLE, $hgui)
    GUISetState(@SW_SHOW, $settingsChild)
EndFunc