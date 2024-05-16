* Tema: Apoyo al desarrollo productivo
* Elaboracion: Carlos Torres
* Link:
*
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path   = "E:\01. DataBase\5. MIDAGRI"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\09. Apoyo al desarrollo productivo"

********************************************************************************
********************************************************************************
* Superficie agropecuaria
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path\2024 11.05 BD informaci n SEIA.xlsx", sheet("01.Superficie Agricola") firstrow clear cellrange(B4:G1878)

rename UBIGEO             ubigeo
rename Áreaagrícola2018ha Área_agrícola_ha
rename Áreaterritorialha  Área_territorial_ha

keep  ubigeo Área_agrícola_ha Área_territorial_ha
order ubigeo Área_agrícola_ha Área_territorial_ha

save "$Output\Superficie Agricola.dta", replace

********************************************************************************
********************************************************************************
* Valor bruto de la producción
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path\2024 11.05 BD informaci n SEIA.xlsx", sheet("02.Valor Bruto de la Producción") firstrow clear cellrange(B4:J30883)

rename UBIGEO             ubigeo
rename VBP_CORRIENTE2023milesdeS VBP_corriente_2023

collapse (sum) VBP_corriente_2023, by(ubigeo)

save "$Output\Valor Bruto de la Producción.dta", replace

********************************************************************************
********************************************************************************
* Número de productores
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path\2024 11.05 BD informaci n SEIA.xlsx", sheet("03.Número de productores") firstrow clear cellrange(B4:F1858)

rename UBIGEO      ubigeo
rename PRODUCTORES Productores 

keep  ubigeo Productores
order ubigeo Productores

save "$Output\Número de productores.dta", replace


********************************************************************************
********************************************************************************

use "$Output\Superficie Agricola.dta", replace

merge 1:1 ubigeo using "$Output\Valor Bruto de la Producción.dta", nogen
merge 1:1 ubigeo using "$Output\Número de productores.dta", nogen

save "$Output\09 Apoyo al desarrollo productivo.dta", replace





