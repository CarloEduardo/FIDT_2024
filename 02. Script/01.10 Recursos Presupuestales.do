* Tema: Recursos Presupuestales
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path   = "E:\01. DataBase\FIDT"
global Ubigeo = "$Path\00. Ubigeo"
global MEF    = "$Path\09. MEF"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\10. Recursos Presupuestales"

********************************************************************************
********************************************************************************
* Población
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\TB_UBIGEOS.xlsx", sheet("TB_UBIGEOS") firstrow clear

keep ubigeo_reniec ubigeo_inei departamento provincia distrito

tostring ubigeo_reniec, replace
tostring ubigeo_inei, replace

replace ubigeo_reniec = "0" + ubigeo_reniec if length(ubigeo_reniec)==5
replace ubigeo_inei   = "0" + ubigeo_inei   if length(ubigeo_inei)==5

save "$Output\TB_UBIGEOS.dta", replace

import excel "$MEF\C02.1a.2023.IV.xlsx", sheet("w2.1a_IV.23") firstrow clear

* 36 609 219 - Total Población Identificada
* 35 411 932 - En el Territorio Nacional

keep   D E F 
rename D distrito_reniec
rename E ubigeo_reniec
rename F Poblacion_reniec
keep if distrito!="" & ubigeo!="" & Poblacion_reniec!=""

destring Poblacion_reniec, replace

merge 1:1 ubigeo_reniec using "$Output\TB_UBIGEOS.dta"

br if _merge!=3

replace ubigeo_inei="130112" if distrito_reniec=="Alto Trujillo" & _merge==1

drop if _merge==2

keep ubigeo_inei Poblacion_reniec

rename ubigeo_inei ubigeo

save "$Output\Población reniec 2023.dta", replace

erase "$Output\TB_UBIGEOS.dta"

********************************************************************************
********************************************************************************
* PIM promedio total
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_vxRub_03062024.xlsx", sheet("PIM1 RO+ROOC") firstrow clear cellrange(A5:O29171)

rename UBIGEO_SIAF ubigeo
rename O           PIM_1_RO_más_ROOC

collapse (sum) PIM_1_RO_más_ROOC ,by(ubigeo)

save "$Output\PIM 1 RO+ROOC.dta", replace

********************************************************************************
********************************************************************************
* PIM promedio de inversiones cuya función es subvencionada por el FIDT
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_vxRub_03062024.xlsx", sheet("PIM2 RD-CANON") firstrow clear cellrange(A6:N52075)

rename UBIGEO_SIAF ubigeo
rename N           PIM_2_RD_menos_CANON

collapse (sum) PIM_2_RD_menos_CANON ,by(ubigeo)

save "$Output\PIM 2 RD-CANON.dta", replace

********************************************************************************
********************************************************************************
* PIM promedio por donaciones y Transferencia
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_vxRub_03062024.xlsx", sheet("PIM3 CANON") firstrow clear cellrange(A6:N103673)

rename UBIGEO_SIAF ubigeo
rename N           PIM_3_CANON

collapse (sum) PIM_3_CANON ,by(ubigeo)

save "$Output\PIM 3 CANON.dta", replace

********************************************************************************
********************************************************************************

use "$Ubigeo\UBIGEO 2022.dta", clear
merge 1:1 ubigeo using "$Output\PIM 1 RO+ROOC.dta", nogen
merge 1:1 ubigeo using "$Output\PIM 2 RD-CANON.dta", nogen
merge 1:1 ubigeo using "$Output\PIM 3 CANON.dta", nogen
merge 1:1 ubigeo using "$Output\Población reniec 2023.dta", nogen

br if inlist(ubigeo, "030612", "050413", "050512", "050513", "050514", "050515", "080915", "080916", "080917") // 9 distritos 
br if inlist(ubigeo, "080918", "090724", "090725", "130112", "160109", "180107", "221006", "250306", "250307") // 9 distritos

mdesc

gen PIM_1_percapita_RO_más_ROOC    = PIM_1_RO_más_ROOC / Poblacion_reniec
gen PIM_2_percapita_RD_menos_CANON = PIM_2_RD_menos_CANON / Poblacion_reniec
gen PIM_3_percapita_CANON          = PIM_3_CANON / Poblacion_reniec

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\10. Recursos Presupuestales_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\10. Recursos Presupuestales.dta", replace




