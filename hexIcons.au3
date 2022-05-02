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

;==============================================================================
; Filename:		hexIcons.au3
; Description:	- png icons converted to hex for use in the program instead of
;				  requiring external sources.
;==============================================================================

Global Enum $pngAccept, $pngAdd, $pngBigicon, $pngDelete, $pngEdit, $pngRefresh, $pngSave, $pngSave16, _
		$pngSearch, $pngSettings, $pngTray, $pngWarning, $pngMax, $pngNew16, $pngRefresh24, $pngDelete16

;Get icons on-demand instead of keeping the data permanently in memory
Func GetIconData($iconSel)
	Local $icondData
	Switch $iconSel
		Case $pngAccept
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABgAAAASCAYAAABB7B6eAAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAMfwAADH8BdgxfmQAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAAMqSURBVDiNrdNbSFNxHMDx327nbDtnOztnunmZ5mWK1w3B' & _
					'qJcsU8vE5iWlp556yAkFQVQQSAVFIBVlkfdLJPRWqTnFkt5rQ6broYQscjubmztz' & _
					'16bbevA675Hn5cDvcD7f//9/OCw4wEtdKqtFUG4LsMEYNsM5vd7s4xwUXlAm1+Ak' & _
					'v7v2slomxJDkWdpZTSkErw4koC6T1eAE2qPRqki+kAexCpyDIGyJ3ewrZP8vnl8i' & _
					'q8bFaJemQU3yhby1ubJAhrIjERX3f3DVSflZnOB1VWlVJB9bp4KBEAy+MDKLwciN' & _
					'1SnrSEX8XeCyjvsX/I3GT86pvXB1ibwSEyN9y/j6yhf/hGCw1ci4ncGrhjG6nw0A' & _
					'rMLy+JdJOdSVUxeyj6GYYDy/SJ6/G55fHFchJHh9VY0qUoBH4wNtRmbBGbhmGKN7' & _
					'AQA4hysTnh3Koc4X1WaIMQKFpEwS+2Gy10kUvOG5Gf/clmM5EVsuIpH+6kY1FYUH' & _
					'QzDQbmRcc4HrE2PWztU5GwDqimqUIhZreUDFCaHiYm4sjqHjeUXS7KhjKZadxkm0' & _
					'X6ONXvlSMAyDbZOMdz54c+KDtWPjO5zETJHU9tujSsuToqyVilCEQIKSxGZMjvoY' & _
					'BX/QOuNzFJTKSwUE8rqqQUUJxUg03m5k3POBW/oRunXzjjnmb+6PIoqbZDd7MlPz' & _
					'YvgbI4lKCTZjctRLE/mMQIS0VmnVUmwTPtQx6WLm/U2GEevz7b4XBwDAMu0ZFscg' & _
					'6Q6rV5mSs2EnYgTiUgmc/uku0VxSEVvwzknGZfM1GUatLdvhawEAAPN3zxBOcTOc' & _
					'Nn/6cmR5jhEo5ByNRxD++k8fWgzD+64phrH77hhGrU93wqMCK5EBnOJmOWlvWkpu' & _
					'zFpk9Q4AEApFQNc15XTZPPf1Otuj3fAtgZXIO1zCy3bP+1OTs9Z3AgAQXgqDrtvk' & _
					'YqyBB591dPNe+LYBAADztOetgODmephASnIWha7iwz0ml93iffxlxHJvP/iOAQAA' & _
					'y7TnjYDkqt3OQIpCKUF0vV9djlnvE8MofXu/OAAAa7eH9fXA+RVI6IyEI2dC4Uiz' & _
					'Xkc//BccAOAvk3E1iekdJvMAAAAASUVORK5CYII='
		Case $pngAdd
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAPgAAAD4ABMkKt4wAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAAIMSURBVEiJrZXNaxNBGMafZ2Y23S0ehGAqiKAgTVok6MFC' & _
					'8SB4KIq1p/bov+Cp/4I3T149KIg3L4peBS9+IKFYExSsEFAUES8ezKY72fGQzSab' & _
					'zExCyVyW5d3397xf8y7hO3VUQhm8i+PkjM0cLZa+drqHl9HELxdCeQU0Nqr1pfLt' & _
					'3atW8727LysfGt83ADxyIYRXIIVSUtAZnRSEgfQh/AJTDv3sfhBHRQtKCHdyRxfg' & _
					'AE4JYM4CQ7iCoARnEqihDIEtpAgmrALrRbjKoxeUIAkIXEENJUs0MQxeqDAKGueq' & _
					'J8rSMS3LqydDQhTAA6GV1dORTswOwB2SWRgESfR6qWm12neIFZj7j285G0ZmcMiJ' & _
					'DIrvRZsxAtdv7vp7kMOpMoHp4MG7Mcx64IWPOWM6OM+Awi1QdBxxzspEDzjPgI4M' & _
					'vDV2lmlkdH0ZzFRj+EszngEXLqpvy9XKcSklR0cN7D/rF86GmzcuyWKZ+qBnz1/3' & _
					'9vYO4sH3Apk/Ca1Ts9/68kd1Y732cf/HNddFKwWl7a3N9WO2DJrNduft+9YTpHhj' & _
					'8U1APFX4hJ8AHlhHqYZDktsTpcibTSDFK3zGQ8cwzrKLxlfEsNmz7aJpeBKSlvGE' & _
					'wly26eSSGzabnMu6pn0coebwRyN6WqfGdS+SRBsIaD/Cd85jKQwWGnHcPWUzL0ZR' & _
					'+9/fzhoO8NuF+A/lOnTXVv7rjQAAAABJRU5ErkJggg=='
		Case $pngBigicon
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAMAAACdt4HsAAABTVBMVEUAAAAAAAAC' & _
					'AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAgIAAAAAAAAAAAAA' & _
					'AAAEAwAAAAAAAAAAAADLoh/16G7U/v4BAQD//9YMCwMLDAwbGQsTEQYSFBMeGATv' & _
					'4mq6sFMkIAyRkXnGnh43NBjP9/fKv1qvpU6mhBgzMytNSCEYGhctKxPbz2GlnUpX' & _
					'V0knKibCmx2uixqNcBSGhnHCt1ZtZzC9lxx9ZBK84uKTsLB9lZWnp4ycnINgc3Nt' & _
					'bVxmZlZhYVKelkaMhD4/PzV1bzQeIB1APRyUdhZ2XhFuVxBiTg5QQAu019fk5MDd' & _
					'3brT07G2tplVZWXUyV+VjUKDfDopMTFjXSy1kBuefhc9MAjF7Oz19c6LpqaEn59w' & _
					'hoZ8fGhJV1c+SkpNTUBWUiZZRw1IOQs0KQerzMzt7ceevb3o22iz0yY/AAAAF3RS' & _
					'TlMA8fqnXC/iPwofsE6cE4XYx2PRd7+TbZ9gZbEAAAP0SURBVFjDtZb3b9pAFMdt' & _
					'AwbKJgPzfF7sDYGEmR3CSCC7aXabZqfj//+xHiw15cBI/UhIh/D3w733dCcTGBzm' & _
					'Rfs8TQIARc8vGB2ELkxON4XeXzvFm+TKSrLYOZQog2nqtGPRC7edZMQ3SvKQck4Z' & _
					'd5JSrer7yI1gnyZvo6V9379ZQcbJeSfq+MZSoyfFjQaU9I1nGUz46t3CLXqLYAwS' & _
					'vgb37bLvWjrECN49uPyiUFU6dYjZgmTDCeiaD09SACdufigyQRDZL+IGadeKx1Nz' & _
					'jRe4ilMIqmAdl7dQK75Rrm+Sy/8wCOZxAiuMPl+UgAP0WtUxBxOM9PAAto5id2sF' & _
					'SdvV8n5tv6dHmB0cDA5Rh/vlV4g9SlW5+QeIa3Ooq/zBCjX+YiHhpl8+uvdrxAqv' & _
					'vsht5lvMH7sX3+Sfum7MGKVBAZf+PmtQPcisqssjsZssIhvmJEoRX6TYrSWXpfWB' & _
					'ICZ2Ya23/gYUOUeMx0K/Xb+Dyg//gCd0OZC15TgO6zzIpFIAq0PBZ9garg3EBMxO' & _
					'Lsyym3A0FDzCsJ7vpEf+G/xtLrIy7bWh4HJUALTRC5g5OAgT95Vlv4qfB5lVaI+U' & _
					'AJAJb44/DUaK9ngLqdIOxw2asJUqFQZNzOS3T/JyGeMw1DczZGazANvNp5iW+QVn' & _
					'x1y/oHvxJ9ucx/TATNaPd+DkWISNzNOqOnnugWVLotbTH0qDCzbsHN3PbP1UnkLh' & _
					'NMU9ft+6lCMyeXH9zn+3zuXl9mSwAsKYUgIb2WiePdtpPpeOWZWwCCLwaW4n3PQS' & _
					'WMyi+nw0x5fYUerpRDnABK/2YA4vcFCn8uOpCyaINvrhnw/sKYozKl9oB4HnU509' & _
					'yYd+M8zSwFBKsc0XLX8u2IgJWGkR0jmGUQxhtZwd7mwbgmo+ELUTE3EKcUYjyD+f' & _
					'yIJtOc8zKi2XZbLARiWYvgEgH954aGejFUahTE31jmNEfUOAb7RCofRugA+qX7NT' & _
					'vuF40G7PUEkzlVCOiaOAOoHRAvBVkC01weRQIg2hXGNP249x+lc8V/RcNTQEHiC0' & _
					'11LWCZqYHou9N4sKKCwpy6sFQg8L8rbVGMio24kadQmsVE6bRAhA6yFvJnTh7Y2i' & _
					'AZBlZhHYK5ogB/Ayk2Bxj9HIQmUmgZnvCV6gMZPACr81wYU2RUYw6RNYyN6pXIIg' & _
					'RoDBtdQ/k5oJ6RV8ugqW4/F4eRd2E4lEMKhbMEeDICBB4PmQjACkXgFhoc6ZARfz' & _
					'hH7IoBYOyJ/03AyChah2lWcDuKOEfeVRBlFWr7ioR3/ebCBRtFX+kr1IZ0PIbbTo' & _
					'HSP8BanvRvHAB0hde/DCByhdAjt8wKVvBHOGTxqGHnYT8T/4AxAm33r9SQ6bAAAA' & _
					'AElFTkSuQmCC'
		Case $pngDelete
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAPNQAADzUB4fd12AAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAALmSURBVEiJtZbPa9NgGMe/ed81axJlS0bWH+BJhc5B2W1T' & _
					'RAZjP07iVNwPUEbZP+VljJ0cghQRZTvJLiuImx5EL0rncLbr1ghttyRN38fDzGi7' & _
					'pltFn+Ob8Pnm+fF93kgAsAAMaYy9kCSpeFSr3V0C9vAXkQLiKucvicioCHF/Gfgg' & _
					'LQBDYUnaeBKNXsq7bm3dsn46Qox0KpIC4jJjmxO6Ho3KcmgllyvbRHf4LcYyj2Mx' & _
					'82ZPj5TQNOYKoe44zmySaHUbKF0U3s1YZkLXY9OmKV8Jh6U+WZY/VypTjAHFvOt6' & _
					'/svTphka1/VoN2OZFBC/KHxc16PTphnyz/Ou6zGgyJNE6axtz1SFUBOaxgFgQNN4' & _
					'VQhtx3HmbxCtfgzIZBGIyIxtjvb2xh7298v++evDw+qbYnG/LMQY3wIqQ0TPso7T' & _
					'IJLQNCYBSta2W4osApEQY5nR3t74oyb4q8PD/YoQwyvADw4AQSLXVZW3EvHhE7oe' & _
					'f9AGDgBSp18lA54Pv2eabeFnBPymyZKUmTSMSD0gXSh4a5aVAxFNGEZDQ9MHB9W1' & _
					'YjHvCjHcPN68WWAbKCWB1azjzHtESkJVT3viCaFeU5TLF4W3zOC8ctVHulDw1i0r' & _
					'31yWthn4sQVUkkTPd217ziNS/MY3fLll5V0hhpfbuJ4FPfhXEZiBb6JJw4jVN9uP' & _
					'hKpyBijfAnzSViAFxEOMvWuGpwsF78vRkUhoGgNOfFIlUr7b9lzQ7jojcN6Yfj0+' & _
					'LlWJlAHf8arKPSIlGyDSILAARMMnZYk2w9ctK38kxIgEPM06zkylVlMH60SCysXr' & _
					'4cqfldsK7o+iv1Z2m0SC1grvBO6fdyLCO4V3KsJvM7YxbhhXWzX0PBOdmtFx5r2T' & _
					'LdwwXXu2PcYEYERkuasV/CL38hKw5woxvGZZuXShcHozRmS5SwAGHyR6+6lcnu8L' & _
					'heT3pVKtE7gf20ApSbSate3ZKpHyy/PYSi5XPiaakoD/+9vyG4IKQs0zHCz0AAAA' & _
					'AElFTkSuQmCC'
		Case $pngDelete16
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAKIwAACiMBfBPMxQAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAAKNSURBVDiNpZNLTxNhFIbPXCDTrzOdKdAbSjpjFyRIaTVp' & _
					'iJsWosGU8BMsBRcksua3uCSUCom/wLjRQsKqIm1NQFBkwIDUXphxhoHO5asLJcEE' & _
					'iAlnfZ7kvOfJS0wD+PyC8JYA0A8VJZ0HOIUbJgPgviMIb9oA7E9FeUqNCcLai4mJ' & _
					'+EAodPfL0VE6YppLFQDrOjjAcSvZ0dHEo2g0tHlwMEYSGOtnqopFjqOyiUQ8gNBK' & _
					'BsB9JYzQSjaRiIscR52pKiYw1qn7rdbrzcPDdB/L+u+xLB1xu4Nfm83xftte3gAw' & _
					'AQBmAFAPwxSmBgfjktdLy40GXlhb+1TXtCfExYLH5Vp9NjAQizAM/b3ZxAu7u+W6' & _
					'aaZoAIfv7CxMRiIPxK4uWj4/x4tbW5WGYSTnATTi4sRZABYxTGEyHI6JFEXLqooX' & _
					'q9UyAOCM3x+TBIGWbRu/2t8v661W8iWADgBAXM45C8Cijo5CxueLi+02tWcYDgCA' & _
					'hBAlE4STr9VKhmWNXMDXapqj6Q8lj8dSGKatMEy77PE4czT98arnkjc5/5+5dQTq' & _
					'H5hhCpOSFJMQovdNE+dPTioVy/oRZlm/JAh0mOeDn3V9POY4S8W/ikmAPxrdCL3L' & _
					'RqNxqaeHljHG+Vqt0rTt1C/bTubr9dIuxrbk85HTQ0MxFqHV5wAcAAA1A4B4jitM' & _
					'DQ8/FL1eSlZVnN/erjRMMzkPoK0DWIOOs7Sj6+m+7m6/FAxSkWAwsF2rpftNc5l6' & _
					'7PG8nx4ZSYg+H7XXbDq5jY1S9fw8mbuUcx3Aitj28jdFSYcDgYDY20tJoZB/5/g4' & _
					'RQJJul08T8qa5uSKxVLVMFJXNTIPcFo1jFSuWCzJmua4eJ4kSNJN3LbOvwFR0zR/' & _
					'yIVS+wAAAABJRU5ErkJggg=='
		Case $pngEdit
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAP7wAAD+8BKYVnBAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAAODSURBVEiJrdRvaBtlHAfw7+Xucv+fXOuaFAuXpE3orLrO' & _
					'xiZ5IfNfnXaZvtjbIjiGoPhOfSV9pzBfOBi+lekLQQx1w7lU6zYGgswurnVMO1ad' & _
					'VbIye1lzuWvTXdrmcr5p5pY2aTv7hYOD5/d8P/ccx1Gd4aBVcVyCukg8PbdUdgZy' & _
					'udxU/dp2Qmma5n7/YRKtsve+henZEt78+NfFxTurQ7lc7syDAh4AICILIjH3Xf3d' & _
					'Kk68vUcRvPRIKBR6438BjdLb5cMX7/VxIuc5Hg4H39lxAAB6ggrSwzFO5pkPol3h' & _
					'93ccAIDIwxLSwzFe5DzvRrqCH20LkHh67satJXezwXC7iPRwjFd45q1oZ+j4VgFa' & _
					'lMjYuYnbryZ3q1x7K990WJVZDMYDTGZc36sopKNgmN9uCliWdVuQlKnMpfyhpx5t' & _
					'ZfwtXNMNishgMO5nMtn8Y5JMggXDzDQFAMCyrN+Jz/fP6Z/0F/c9/hDTpjZHZIHB' & _
					'y8kA+93P+R5BJLsLhnkawIavma7dmKb1i4+opTPj+rPPP7GLaVW8G83fjcjROJhs' & _
					'Z8cu56NeQdprGNYpANWGAAAUTXOcELL89cW5fQN9bUyLwjZFBI5GKu5nz07OhzmB' & _
					'9BWM4sl6hK7fVDSti0QhwmhWf3IwHmAVkdkUOZgIsOcm80FOkJMFwzwJwGkIrCEX' & _
					'FNnXlrmk9w72+1lZaI7wXhqRDpkd+eFW1O9TnzEs6/PaSTYEAMAommOSRHZlsnpv' & _
					'KhFgJb4xcv1mCUeOXUHCI7leyhNgfaR/3jRHAFQbAmvIWVEg2mg235OKB1iJXz9+' & _
					'/WYJQ0cnEauK7me+TuoVXmUuLC9oDCGJYKRrpCkAAIZpjkoyCY9m9Z5UIsCI9yC1' & _
					'8nhVdE+QMAUAHOVBilfZ8ysLmnGnFNvKv8idvvHX6wVr5cuhoxN2cXFlXfkna+W1' & _
					'sKAgUxRcQN30BLUUimaGFZQ95yfnw5EOmT1y7MqG5bZbxWFrpjzllK8WbXs/1aiw' & _
					'QejuaOgbe7l64GlOcT8lnevKX7P+LE9V7MtLjrN/dnbW3tLv+p4403/8fYgD9eOc' & _
					's1pecO9+7mvlM+VrleWJWjkAbPcE/51EC6Y7aO+BtBoVOIrCYWum/JtjXzVt+zld' & _
					'15dqgw8KAADTrYVOaYx3QKFo6lqlPFFyVl+oPflOAADAPKKFvoKHalmsrL5UXw4A' & _
					'/wIPhVeXH4Cx+wAAAABJRU5ErkJggg=='
		Case $pngRefresh
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAPNgAADzYBTE5UtQAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAAWkSURBVEiJnVVbbFRVFF3nnPuYuTOdmToUaaG006m1UKyI' & _
					'hodURD+sU6iCRqMf6ofxbYzyR+KToIiJCXz4ipqIP6YxRAngUBGjViwopYLYCrad' & _
					'DqVQ6Qyddh73fY4fpVBalOj6u2efvdY9e++zDsFk1DTPgG3NA2gtqFzHJPVGIZwa' & _
					'IbgqLDMGRsNE1h4h3DrHLeco4LYj2doJQOAfQACA1dzzGRdOMwRXJX9JQSmuZGo4' & _
					'qinF5UQOzsHwT+/ljKHfnqBSYENoQVOUSCrMdH9BHzwC4Vo57ppvgop30RM3pwpI' & _
					'AAjndtOMZY/5gvNXA4QEpm5ysn8JcNYrnMLcUP0aMG8IADQA0E8f1VIHt220UokX' & _
					'+NxVa3Fyd8fkXApACG6vSrV/VMgP/DL9jJzDyac1MJIHlfl58gvwltWjfO3bWknD' & _
					'U3OIIrWhsunuyXEGABjpOYlQROgDh1eErlvDCGUXNtjZIYx1x/NwnTgEfzjz63Zr' & _
					'tGuPbp79k1PFJ8uBWQAAtSRKvGUL5GxP2xoEKvcj09N/oQeYs3o28dLjZXe+5vPO' & _
					'XnjJHxYGDmFo3+bfuJ5tBOgswM2ASDNB6e1UUp5TiiuKSu9Y75P8JQCAfP8BnNm7' & _
					'OSP0bDUG96UpABCfsiVQG5MnyM1UHwoDhwAAVmYQ4Px3JFvPIBnvRPLrBPq/Ooi+' & _
					'XZu4zCqMVN/WZMszhpUZAAD4KpfCH23wUC3w1niJqmNziMA7pXe+qlJJBbd1nPry' & _
					'eT17fK+rzohKxtluy/irqwUjPT9O689wl4uR49+SYCSf6/95RWh+k0wog+fqWilz' & _
					'5Iv5CEY/ohDkQV/lzZx5isbb0fm5w21jn3Ds2NDe1/P53jYOVxyY3v1Jc9C3e4tr' & _
					'jB0aObaDA4CkXQVt7o0uGO6nTPbd7atc4gUACIHRrp22MI2X0b/nO8GNpa6ZfQbJ' & _
					'Zd//mwAACCf/YuboDn3iuyjaoDHZf68kuFOrhqvG6z06COHaJpLxTgBA79fHABwD' & _
					'4lfiBxLL9vOqDsnVM2DeEJRwFYTrzKPcNkOSFgYAuPkUiKScvjLb5fAqJ5Jy1sml' & _
					'AIyXSbhWkIJe9BGq+gDuFv0/AQCgFncnu4UglDJ11Cmkz6vOgHCsEkzcj/92Aipc' & _
					'o1wJlQMAnHwahKkjlDDWbab6AABMKwb1BFxEGhuuTHgfQyT2OKqargMARNpvoorm' & _
					'MM+4lVnpBAiT/qCuVfg819dWmEgL1a/1Ell744r8c7MrmRrcSqjcjopVtxHJvyFY' & _
					'16xMhHOJA7pr5b6k4GZLYeAQcwrnxgXq7qLME1hEq1av+1cBShf7o8tpWeNLPiKx' & _
					'OFU8txQvvFcCANcYQz55kIHjM4ZMIk/D8yNOIT3PH7lZIpRBK79JHvvz21tFKFqE' & _
					'0ut/wHCXO5Wfzax/1l+94vqimtvgmXmtFKxrkuXzfpT66UPLGkluF707tzEAEN7Z' & _
					'++3c0NPqVRUeJVQO5gmg6JqVkjHUfYObSz9LQ1FNhK4RCNQwhKPV8EdAVO+60LzY' & _
					'TDlYBjlYCkkrBgAUBjqQOvCJLmy9GaO9uYvTUhm7lchKvKxpo9dbuuDCsj54BGMn' & _
					'vjGMM8ds1xiTuG2ogIgRqmyveOB9/4RdA4BwbSQ+fch2jewr6P9qEzB1HCOxZsLk' & _
					'lpLlT3kCtY0EZPq09n68xhSOuZhAOlz9+A4GSi+JF0524HTrRl24eiMSrW2XRhPx' & _
					'ncI2G4bbPzh5ase6vH76CCAuvueungG4TcElH/OHC1PJAUArX4SSZY96CVV3AeNv' & _
					'8qVIth4WdffVGMMnnjyz57X1YCzgLa0Xajjq41YWRPKeElyvlgOziJnqg5U5BWtk' & _
					'QFjp3rx5Lsmd7FkNhBlUUna600p0OVQ2LQT4EkhyPaXMB8E7uW0fJEyJE8osQtkJ' & _
					'1zE7wO3fQUQ3TLsbg/vSE+l/Axlqcm0XPzm2AAAAAElFTkSuQmCC'
		Case $pngRefresh24
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAM1gAADNYBN9oYHwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAAS0SURBVDiNjdLZb1QFGAXwc/dl7qzUaTvTbTqFthkEGoqU' & _
					'kU0srSzFEm0ikBijGB+MMT4YEh40QZ40oqKiCUF5MBFEECqbiFQRiSlLaZBOB6bT' & _
					'jdZWGGZ6Z727D4iRAOr5A375vpNDAABqVnAwiRmwzDpRFGeJgtCo63qdpukelmM/' & _
					'ldPKaYK1bbJg3rQU+bSpFL7C6PfjuE8IBFu8Nt7WX1MdMII1NVwgELD7/OUo9pWj' & _
					'P3oVH3+w7cu0Skz3Ln6lkaB5FCb71anI8Sx0NaLnEy9g6ET/P0EaijNN2Yhbbe3t' & _
					'VQvCiyjNAFQD0AxgcHjMTOczF02LbxYrGkGQNMSyOaxn7jNs7vql8GTXu7+atU+9' & _
					'YUb3b78DUpD7dEXy7znXfeHFmvrZguAoQk4D8hrQ9cNxeSTetxsWuc5UMhklEScp' & _
					'TqIowQXGUQJnfSufH+kJmzZfxkpEum+DACh3qNVfUdHevGYdXzBI5DUgpwEnD+/N' & _
					'yHLiI5hWb+GP/n3KRN+5zMDp4mz8LC+UNfC06IYUXMSnY11h0+brRvLaEIFQB2sj' & _
					'iZHXt3xYLLm9GLgWRTKZMIIPh6n3N61PZQ29GFf2qXc1X7NqDUXbP/O3bZ0mFQdh' & _
					'JIcRP7AppkX2ziApJd9RP3u+QNu9SOZ0fLHjrdTB3e+NdZ85aRiGodyDAUDsSKeR' & _
					'n1r++/EtKRuto8hXCWf5zIcQbHuSFCTHc6GmVodcAM52fadpmvZ1Qc02/nxoVw9J' & _
					'0bvuNw0AwPCxHphKZ27wF1NigelNa5y86HiJ1jVttlRaC1kBIhd+nCrkMtsRP3aj' & _
					'AMx7IPZXtHRm+2Tv0ZV1c5cUOYP1uGhoDbRFEGxWp6HpQOrGGAXBFv0v6O/oZCSf' & _
					'nCAlFmAoBiDA0ZYFyIXbuwNBA8kMDeDe3u4XUTcsyyAkDmAogARAWpapTOV0yArA' & _
					'OktMMGrd/77QMOs8Xr8hsYBAagCgkATB9ozH+yAXAEf9Kg8lul/7N8M2a8PbQmjd' & _
					'eQRbvKLN82rDgmUuiQMSoxEwLHORVJXUJ9cvHEylFYCrepQgaHY1Klc0PAg0Df3Z' & _
					'lo6Nc3jOeZ5m6LXhpY/TEgv0nDkhZ9Opz2nEjnZmGSmhJodcrLsKpa1vusaPbD5p' & _
					'BFdvxMDhb+7SQh0sRZFc0+JllMcl+DzuaZRToJG6OYG+3u6s4Zw4SAGA5az4LTfa' & _
					'0+6obeYZuxf2msWCciPaCkfVBriqJcsRqIB7ehhG3ij1V69f2twqVpSXkyXeaWAI' & _
					'Hdu2bp66devm89aVnyIUACAZG4SjOpMdPb/QXr2Io0Q3HLUtvFj5SDElepawnvJW' & _
					'NRFvg2WemjVn3tr5TfN5gQEEGhgbuoYj33bmVc3ajFQ0S935xkpEui3BJ09Fjy7g' & _
					'PAGecZYSFO+EUBKiRH8Dn7p8KElZRHTpssdWzqyvJQQGEBigrLQIgUo/e+lS7+qC' & _
					'n91J31V47MAOVLWcmux6ZydBMSFH/RMS761jLK0AkmaG7SI3N1BZRpqKjMGxEYyP' & _
					'XsfgYFy+GhtQVVUphep1EQ/cR/lyH8kyTxOccyFBkkWmUdjv4rliwzBeJkhM0TTd' & _
					'n8vlu3PZwmVYVgR2KYYr+9Q/AW2CBC7NpAEbAAAAAElFTkSuQmCC'
		Case $pngSave
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABcAAAAXCAYAAADgKtSgAAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAOyAAADsgBTlyBbAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAAKYSURBVEiJtdTNSxRxHMfx98zszO5suqurZospbR1a0fAU' & _
					'qAtJHcyLxAZFbV66RJfo4VhI9QekGPRAIFSIRB6kB2KzID34FygYRVEZZpbrs/vg' & _
					'zPw6CNuu7ZOGn9t8v8zr9+X3ZUaivPw8qnoNVZUAsCxFX1wsqa6pmSVPJFmS1oSQ' & _
					'pr5+K425XPOsrPxibu4QMA8g4fVOyrd7diOt20QiNA294cHjRxlBy7LouX6d2GoU' & _
					'gWBvc4Dng4OMtR2FmRnL6u5+z2wkAMzL2O1KEi4ga4kE7168hKUlZj59JtzX97fp' & _
					'98vy5St+iotHAY9csJoSXdeprKzEqesgRHrTv1+WjwerKCoa3hKeN9XVReh6+fbg' & _
					'oABsCY/MzjI2Ps6P6Wlybcu2WdjucHC1u4tEPA6A7vNx/1ZXgbjDwcTHD7QePlLQ' & _
					'YaYQrMai4DhWAO50Mt/Zuf4V/Ge2a6HAxskXFqi8e4cSyygYcGCRMA0iisbPC5fA' & _
					'5cqMu4de8/B0G60HD2xuxOgi4eFRQuFXLJw8lSynXYt9eYnqnZ7NwYCp6tSUubAv' & _
					'LabV0yYXssyNp2HK3G40ReZiKMi9J8/yLkYIwfepSYTqzo5LNo0TobP4fD40TWNP' & _
					'fT1ndtVhGLl3YJomExMTvB0czI4D1NXVUVtbm3xuaGjIMzcYhoHY+APLhKemv7+f' & _
					'kZGRrP2WlhZCoVDWfk68vb2dxsbGrP2Kiopcr+fGBwYGCIfDaTVFUejt7cXpdCZr' & _
					'ma4kL97R0UEwGPwHT4UBlk0zCx6PWwgBkkRpIEBVVVWyqWkamqblOh+ABKx4vd4d' & _
					'Jc1N/BYC1tbAMEwJj+ccdnsnqio5VVXZ53Ipkmkm8oopMQzDFDab/iW6KsVicUks' & _
					'L0cxjJt/AGWf2kIVsXjlAAAAAElFTkSuQmCC'
		Case $pngSave16
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAKVwAAClcBp/M/4AAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAAHjSURBVDiNjZFNaxNRFIafO8l0Mkm0CcFpoxkoYrtIRVJw' & _
					'UbB0Zaw2de0fCN0kmKX/QGhdBSsUf4ErJWLFhRtpxYWLgBZUkJpqJLZuajV08nWv' & _
					'izTNN/pu7r0v530451zB5GQO276EgFO7X0Px+flfQso6PRJCaH+U0je3Nv1lw1Ng' & _
					'ZyfB0dE3wbX4F215eQLg/MZzcg/WerPcujKHZVl4xsd5D3y/voBcvfeOfH5JQ9P6' & _
					'Ar0Kh8NcjEap1Y8b03VE5jbY9ob7n+ljNeo9U7lcOqGQ+V+A/b0feL1eNI+n09YB' & _
					'ugBVx+Hh+nof4HJiCdVoUDFNatvbTVMpHVBdgOLiDe4fHva3MGa174nF5imlDlTb' & _
					'ACkxPn7AXakMHUVTiqphUInNAKobEHn2lLXpc5wNhoYCGij2Cp9J5x5TvLqgKzp2' & _
					'EKg63JyNDQ23VB3zE/j0kmJzB22A04A7L/JMWGeYmY7y6vWbgYCa41BBb43QBnhO' & _
					'B1i5u3pSOBtPDASUy2UepdMgVf83tpTNZimVSl2ebdukUqlOSwwF+Hw+gsFgs0oI' & _
					'MpkMhmEM7MiNlACM+P0nZjKZHFgM4EiJ2zSbDyURTE09IRKJXRgdHZmzLM1VrztD' & _
					'08DvWk17e3BgFn7uK1XY3foLS4ebi0+2J4UAAAAASUVORK5CYII='
		Case $pngSearch
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAPgAAAD4ABMkKt4wAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAAD5SURBVDiNndE9L0RBFMbx390lIkLUEpUoVBo0EtFsoVIs' & _
					'ofUFfAy1aCUKjUazicaqFD6DToioSRSbeAnFnI11171711PNzJnnf87Mk/lRhi1s' & _
					'4C32NbzgCI9KNIlT7ISxVzM4RrPInIV5vqwDDrD+V2EbuwPMpOecoZ4vnOgfu0h7' & _
					'WMtT3/FVEXCD5TygqhlepQ//BRgZAjCHhzzgWYqqijbRzh/OSjkP0gIOi4pNKeda' & _
					'ifkuuo/3FrqZ3uIzIFPoYBSL2MdK3G3E+hwf9OdfxyqWMI17XOIpOrcCciX9R6fw' & _
					'wQUaw4UU/TUmhgWISdoBaf0H0IW00PgGTogouhCe70QAAAAASUVORK5CYII='
		Case $pngSettings
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAMqQAADKkBZQnCMgAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAANmSURBVDiNlVVPSCNXGP/mzU43M2k1hnWqLtsg6E4GxKTo' & _
					'JfTQpMGBhPQwRA+5tJgVtsq2FUkgsJeFslDwuIXA4q5uD2IEoxSZeGlLW3rwsP4J' & _
					'tEoylai7pfUPRiczSWZ2TA+7E9LdGNsfPHiP7/v9vvd+3+M9DC6Bz+d70t3d/QFC' & _
					'CERR/HV5efnTyzgXguM4czQa3VMUpaIoSmV8fDzHcZy5EedKzRzz+/0PSJL8SJbl' & _
					'aU3THiOE7rIsqxoJDofjxfb29lder/c+QRDhpqam4UKh8IMgCJ8DQAUAADeS/X7/' & _
					'N6FQiIvFYtdxHLcDwJ2xsTGb2+2+gRAiAADsdjvFsmxroVD40u12O2Ox2A2SJOli' & _
					'sXgzm80K/9oqz/O/SZJ0ahzvvw5JkqRgMPi7oYOMSalUml5cXDz6vz4vLCz8Lcvy' & _
					'9BuC+Xz+cTqdvlqPpOt6Sdf1Ur3Y1tbW1dPT00fGGgd42U2SJO+Njo6+19bWdq1G' & _
					'qDA1NbU/OTm5n0wmj05OThSn00kghKqFLRbLn6urqx0sy/6SyWQ0PBAIfMswzKTX' & _
					'673p8XhsGIZVGzUzM/M8lUp9LQjCZ5lM5iEAlM/Ozhz9/f1WI4em6XcwDOvQNO0L' & _
					'q9X6PoyMjOQuMPvF4ODg2utH5Hn+qSRJ5XqccDi8g14n1OBcVdVKHT8vJCCEEN7e' & _
					'3t63vr5uOT4+Prbb7SbjziGE8Hw+r1QqlbIoik9feT3m8/k8fX19rTUFivPz8/uz' & _
					's7NSLpf7Cc9ms4s0TT9Mp9PXWZZtrW2Kw+EwybLsJEnyE4Zhbg8MDHjC4fC7CKG3' & _
					'jJzNzc2deDy+fHBwMLiysjJf3a7L5bJGIpFnF/ipSpKk1otFIpFnLper2qSqh83N' & _
					'zbd6e3vL9bzBcZzAcZyoF+vp6SlbLJbwG4IURQ3zPH+tHqkRgsFgK0VRVcHqnevs' & _
					'7GTNZnNHV1cXlUwm9+bm5ootLS3PaZp+G8OwKwAA5+fnysbGxk48Hi8fHh4eMQyD' & _
					'Ly0t/bW2tva9KIoCAABWUwzz+/0PKIryyrL8SFXVaYIg7g4NDX0cCoW6AAASicQf' & _
					'iUTiO03T7hMEETaZTMOqqv4oCMIdePV8NQTHceaJiYldowHRaHTvsgcWaxQEAAgE' & _
					'Ak9sNtuHuq5Xdnd3f06lUg2/gH8AaSzgCD88BzgAAAAASUVORK5CYII='
		Case $pngTray
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAPFBMVEUAAACXfi//' & _
					'5pb/5I7/2Vz/2FT/4X7/22X/6J7/3W3/4ob/6qb/3nb/7rn/33X/7K//6qf/6J//' & _
					'44b/66/dTHNJAAAAAXRSTlMAQObYZgAAAFtJREFUGNNdjYkOgCAMQ633AQj6//9q' & _
					'2Th9C01p0m0QMPTA4ve3XYL75UAsolyCB62nIoRdAehiPLZIZ2rQVefDIRTonbWA' & _
					'dNkY5+Tl4MikylbQpXNFg6WSKg0fFVoEEtsqTFAAAAAASUVORK5CYII='
		Case $pngWarning
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABHVBMVEUAAAAbCAMc' & _
					'CgXWqT+/fRjYohripSWhcwjiqSnxtB9TLgl9QwfMkjV5SQB2UQeYVyasbTbutTB+' & _
					'VgDWmjfQkjdRLAgIAwJRNQA8HgVIJAjqqyf0uTQAAACuaSw0HwC/gjbipjMAAAC2' & _
					'hV/yu0QtEgD42jD43Tn53z7YpiLUohn+63H95mL63lz54FH43ErPu0T43EDKtjn2' & _
					'1zVQSy721C3dqyXaqBs9NxgUFRjdrBEFBQv/7omzrYOSjnf642aCfWbaymX43WPO' & _
					'vWL42lf841bzz1bt1kj430X000X+5ET60ETovESNgUP32EBbV0D02z/iyj/94jrc' & _
					'xTf43TT0zDT1xDT53DLbrDG6hSUZGiDnuhfJkBaiaxXGmhTLlw/hz2/lAAAAJXRS' & _
					'TlMAlpn49fHs5t7T0cfAvbSrnpmYhoBfV1VPRTkxKSMfGxkRDgoKmmtrAAAAAKFJ' & _
					'REFUGNNjwAWU+FVQBQQiRFH4ssxaMYrIAjyO1q68SHxhbxtbh3BxOF+BTcvewkmH' & _
					'HS4g6KxtbKFv5yUE5UuH6riYWxnqarPKgfnKnLp6nn5W+u56HnxgAakQX3V1twB/' & _
					'dQODaBmQAIeRkVqgcaShmpqaCTeQLxJlEqwa5mMepAoEsZIM8iyWlmZmGqamGhqa' & _
					'mppxXAwMEkyMCMAkhuFtANTtFsa8W/5uAAAAAElFTkSuQmCC'
		Case $pngNew16
			$icondData = '' & _
					'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhk' & _
					'iAAAAAlwSFlzAAAKVQAAClUB2A38aQAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3Nj' & _
					'YXBlLm9yZ5vuPBoAAAFMSURBVDiNlZO9TgJBFIXPuTMj/m0WQ1QKIBT6IGthLEwM' & _
					'j6E1USqsfAMjr0FlKb6FhWIEjdmGhEVWYmMsYGWWHUycaubk3HtPvtwhHKcYeB1/' & _
					'a2PP1qLh5DG8iw4WvdrVYN3Llc+bhyVbu2refrm84hJdh6BTdyZYLFRils76M0FS' & _
					'rGhAdwDoYuDdb/prZVsslfI+IbNiDSUG1epuXtdMFyCEBECMRp997td2XhuXRylg' & _
					'pEBxOjlJoESn3zSoX7TeMgx+iy3jvMks0exOMg1RqJxGRQMRk2kMWA3SxbZRZ7UE' & _
					'LAgWA7/j+auVhDpJlCvb/tnpccGedt1qD3ovYQTI1Adi+BH3dNiJghBRisP3iTwp' & _
					'MQWbwXP3ffjQ7qXWG1iySCShuDInzykw5x44VRB6gfyynXMnADPQ/vUX4vGkX2/c' & _
					'5BJYEGIcT/ou7w9MzD6ryePdiwAAAABJRU5ErkJggg=='
	EndSwitch

	Return _Base64Decode($icondData)
EndFunc   ;==>GetIconData


Func _Base64Encode($input)

	$input = Binary($input)

	Local $struct = DllStructCreate("byte[" & BinaryLen($input) & "]")

	DllStructSetData($struct, 1, $input)

	Local $strc = DllStructCreate("int")

	Local $a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
			"ptr", DllStructGetPtr($struct), _
			"int", DllStructGetSize($struct), _
			"int", 1, _
			"ptr", 0, _
			"ptr", DllStructGetPtr($strc))

	If @error Or Not $a_Call[0] Then
		Return SetError(1, 0, "") ; error calculating the length of the buffer needed
	EndIf

	Local $a = DllStructCreate("char[" & DllStructGetData($strc, 1) & "]")

	$a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
			"ptr", DllStructGetPtr($struct), _
			"int", DllStructGetSize($struct), _
			"int", 1, _
			"ptr", DllStructGetPtr($a), _
			"ptr", DllStructGetPtr($strc))

	If @error Or Not $a_Call[0] Then
		Return SetError(2, 0, "") ; error encoding
	EndIf

	Return DllStructGetData($a, 1)

EndFunc   ;==>_Base64Encode

Func _Base64Decode($input_string)

	Local $struct = DllStructCreate("int")

	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
			"str", $input_string, _
			"int", 0, _
			"int", 1, _
			"ptr", 0, _
			"ptr", DllStructGetPtr($struct, 1), _
			"ptr", 0, _
			"ptr", 0)

	If @error Or Not $a_Call[0] Then
		Return SetError(1, 0, "") ; error calculating the length of the buffer needed
	EndIf

	Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")

	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
			"str", $input_string, _
			"int", 0, _
			"int", 1, _
			"ptr", DllStructGetPtr($a), _
			"ptr", DllStructGetPtr($struct, 1), _
			"ptr", 0, _
			"ptr", 0)

	If @error Or Not $a_Call[0] Then
		Return SetError(2, 0, "") ; error decoding
	EndIf

	Return DllStructGetData($a, 1)

EndFunc   ;==>_Base64Decode

Func _memoryToPic($idPic, $name)
	$hBmp = _GDIPlus_BitmapCreateFromMemory(Binary($name), 1)
	_WinAPI_DeleteObject(GUICtrlSendMsg($idPic, 0x0172, 0, $hBmp))
	_WinAPI_DeleteObject($hBmp)
	Return 0
EndFunc   ;==>_memoryToPic

Func _getMemoryAsIcon($name)
	$Bmp = _GDIPlus_BitmapCreateFromMemory(Binary($name))
	$hIcon = _GDIPlus_HICONCreateFromBitmap($Bmp)
	_GDIPlus_ImageDispose($Bmp)
	Return $hIcon
EndFunc   ;==>_getMemoryAsIcon
