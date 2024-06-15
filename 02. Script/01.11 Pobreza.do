clear all
set more off

********************************************************************************
* Tema: Recursos Presupuestales
* Elaboracion: Carlos Torres
********************************************************************************

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path    = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024"
global Pobreza = "$Path\01. Input\00. Dataset\10. Pobreza"
global Output  = "$Path\01. Input\11. Pobreza"

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