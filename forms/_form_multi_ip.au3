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


Global $hMultiIPWindow  ; Handle della finestra Multi IP
Global $lbox_MultiIP
Global $bt_optDelete
Global $bt_optAddIP

Func _form_multi_ip()
	$w = 335 * $dScale
	$h = 260 * $dScale

	$currentWinPos = WinGetPos($hgui)
	$x = $currentWinPos[0] + $guiWidth * $dscale / 2 - $w / 2
	$y = $currentWinPos[1] + $guiHeight * $dscale / 2 - $h / 2

	$settingsChild = GUICreate($oLangStrings.multiIP.title, $w, $h, $x, $y, $WS_CAPTION, -1, $hgui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_onExitChild")
	GUISetFont($MyGlobalFontSize, -1, -1, $MyGlobalFontName)

	; === ASSEGNA L'HANDLE ALLA VARIABILE GLOBALE ===
    $hMultiIPWindow = $settingsChild

	GUICtrlCreateLabel("", 0, 0, $w, $h - 32 * $dscale)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel("", 0, $h - 32 * $dscale, $w, 1)
	GUICtrlSetBkColor(-1, 0x000000)

	$lbox_MultiIP = GUICtrlCreateListView("IP|Subnet", 10 * $dScale, 10 * $dScale, $w - 20 * $dScale, $h - 70 * $dScale, BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS))
	;set dimensions of columns
	; Imposta le larghezze delle colonne (opzionale)
	_GUICtrlListView_SetColumnWidth($lbox_MultiIP, 0, 150)  ; Colonna 0: 150px
	_GUICtrlListView_SetColumnWidth($lbox_MultiIP, 1, 200)  ; Colonna 1: 200px
	; ================================================
    ; POPOLA LA LISTVIEW CON I DATI DI $listIP
    ; ================================================
    
    ; Verifica che $listIP sia un array valido e contenga dati
	if $g_DHCPEnabled Then
		GUICtrlCreateListViewItem("DHCP", $lbox_MultiIP)
	else
		If IsArray($listIP) And $listIP[0][0] > 0 Then
			; Itera su tutti gli IP trovati
			For $i = 1 To $listIP[0][0]
				; Crea un item per ogni riga: "IP|Subnet"
				GUICtrlCreateListViewItem($listIP[$i][0] & "|" & $listIP[$i][1], $lbox_MultiIP)
			Next
			
			; Opzionale: seleziona il primo elemento
			_GUICtrlListView_SetItemSelected($lbox_MultiIP, 0)
		Else
			; Se non ci sono IP, mostra un messaggio
			GUICtrlCreateListViewItem($oLangStrings.multiIP.noIPFound, $lbox_MultiIP)
		EndIf
	EndIf
	GUICtrlSetBkColor(-1, 0xFFFFFF)	

	Local $strOptionsLang = $options.Language
	Local $aLangsAvailable = _getLangsAvailable()
	Local $langNameStr
	For $i = 0 To UBound($aLangsAvailable) - 1
		If $aLangsAvailable[$i] <> "" Then
			If StringInStr($aLangsAvailable[$i], $strOptionsLang) Then
				$strOptionsLang = $aLangsAvailable[$i]
			EndIf
			If Not StringInStr($langNameStr, $aLangsAvailable[$i]) And $aLangsAvailable[$i] <> "English   (en-US)" Then
				$langNameStr &= $aLangsAvailable[$i] & "|"
			EndIf
		Else
			ExitLoop
		EndIf
	Next
	$cmb_langSelect = GUICtrlCreateCombo("English   (en-US)", 10 * $dScale, 28 * $dScale, $w - 20 * $dScale, -1, BitOR($CBS_DROPDOWNlist, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	If $langNameStr <> "" Then
		GUICtrlSetData(-1, $langNameStr)
	EndIf
	ControlCommand($settingsChild, "", $cmb_langSelect, "SelectString", $strOptionsLang)

	$bt_optDelete = GUICtrlCreateButton($oLangStrings.multiIP.delete,  $w - 20 * $dScale - 65 * $dScale, $h - 58 * $dScale, 75 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent($bt_optDelete, "_onDeleteIP")
	if $g_DHCPEnabled Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf

	$bt_optAdd = GUICtrlCreateButton($oLangStrings.multiIP.addIP,  $w - 20 * $dScale - 155 * $dScale, $h - 58 * $dScale, 75 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent($bt_optAdd, "_onAddIP")
	if $g_DHCPEnabled Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf

	$bt_optEdit = GUICtrlCreateButton($oLangStrings.multiIP.editIP,  $w - 20 * $dScale - 245 * $dScale, $h - 58 * $dScale, 75 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent($bt_optEdit, "_onEditIP")
	if $g_DHCPEnabled Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf

	$bt_optCancel = GUICtrlCreateButton($oLangStrings.multiIP.exit_, $w - 20 * $dScale - 65 * $dScale, $h - 27 * $dScale, 75 * $dScale, 22 * $dScale)
	GUICtrlSetOnEvent($bt_optCancel, "_onExitChild")

	GUISetState(@SW_DISABLE, $hgui)
	GUISetState(@SW_SHOW, $settingsChild)
	
EndFunc   ;==>_formm_settings

