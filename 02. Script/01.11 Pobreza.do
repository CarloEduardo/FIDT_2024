* Tema: Recursos Presupuestales
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path    = "E:\01. DataBase\FIDT"
global Pobreza = "$Path\10. Pobreza"
global Output  = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\11. Pobreza"

********************************************************************************
********************************************************************************
* Pobreza monetaria
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Pobreza\Mapa_Pobreza_2018.xlsx", sheet("BBDD") firstrow clear cellrange(A1:I1875)

rename Ubigeo                      ubigeo
rename PobrezaMonetariaMapadePobre Pobreza_monetaria

keep  ubigeo Pobreza_monetaria
order ubigeo Pobreza_monetaria

save "$Output\11. Pobreza monetaria.dta", replace