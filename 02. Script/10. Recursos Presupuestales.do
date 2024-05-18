* Tema: Recursos Presupuestales
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path   = "E:\01. DataBase\6. MEF"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\10. Recursos Presupuestales"

********************************************************************************
********************************************************************************
* PIM promedio total
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path\Solicitud_FIDT_GRGL.xlsx", sheet("PIM TOTAL") firstrow clear cellrange(A3:E2079)

rename UBIGEO_SIAF   ubigeo
rename PromediodePIM PIM_promedio_total

keep  ubigeo PIM_promedio_total
order ubigeo PIM_promedio_total

save "$Output\PIM promedio total.dta", replace

********************************************************************************
********************************************************************************
* PIM promedio de inversiones cuya función es subvencionada por el FIDT
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path\Solicitud_FIDT_GRGL.xlsx", sheet("PIM FUNCION FIDT") firstrow clear cellrange(A4:E2073)

rename UBIGEO_SIAF   ubigeo
rename PromediodePIM PIM_promedio_FIDT

keep  ubigeo PIM_promedio_FIDT
order ubigeo PIM_promedio_FIDT

save "$Output\PIM promedio FIDT.dta", replace

********************************************************************************
********************************************************************************
* PIM promedio por donaciones y Transferencia
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path\Solicitud_FIDT_GRGL.xlsx", sheet("PIM DONACIONES") firstrow clear cellrange(A4:E1471)

rename UBIGEO_SIAF   ubigeo
rename PromediodePIM PIM_promedio_donaciones

keep  ubigeo PIM_promedio_donaciones
order ubigeo PIM_promedio_donaciones

save "$Output\PIM promedio donaciones y Transferencia.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje de ejecución promedio total
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path\Solicitud_FIDT_GRGL.xlsx", sheet("EJECUCION total") firstrow clear cellrange(A2:T2078)

rename UBIGEO_SIAF       ubigeo
rename ejecucionpromedio Ejecución_total

keep  ubigeo Ejecución_total
order ubigeo Ejecución_total

save "$Output\Porcentaje de ejecución promedio total.dta", replace


********************************************************************************
********************************************************************************
* Porcentaje de ejecución promedio de inversiones cuya función es subvencionada FIDT
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path\Solicitud_FIDT_GRGL.xlsx", sheet("EJECUCION FUNCION FIDT") firstrow clear cellrange(A2:T2071)

rename UBIGEO_SIAF       ubigeo
rename ejecucionpromedio Ejecución_FIDT

keep  ubigeo Ejecución_FIDT
order ubigeo Ejecución_FIDT

save "$Output\Porcentaje de ejecución FIDT.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje de ejecución promedio de donaciones y transferencia
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path\Solicitud_FIDT_GRGL.xlsx", sheet("EJECUCION DONACIONES Y TRAN") firstrow clear cellrange(A2:T1469)

rename UBIGEO_SIAF       ubigeo
rename ejecucionpromedio Ejecución_promedio_donaciones

keep  ubigeo Ejecución_promedio_donaciones
order ubigeo Ejecución_promedio_donaciones

save "$Output\Porcentaje de ejecución donaciones y transferencia.dta", replace

********************************************************************************
********************************************************************************

use "$Output\PIM promedio total.dta", clear
merge 1:1 ubigeo using "$Output\PIM promedio FIDT.dta", nogen
merge 1:1 ubigeo using "$Output\PIM promedio donaciones y Transferencia.dta", nogen
merge 1:1 ubigeo using "$Output\Porcentaje de ejecución promedio total.dta", nogen
merge 1:1 ubigeo using "$Output\Porcentaje de ejecución FIDT.dta", nogen
merge 1:1 ubigeo using "$Output\Porcentaje de ejecución donaciones y transferencia.dta", nogen
save "$Output\10 Recursos Presupuestales.dta", replace





