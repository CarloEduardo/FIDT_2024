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
* PIM promedio total
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v2.xlsx", sheet("PIM TOTAL") firstrow clear cellrange(A6:G1897)

rename UBIGEO_SIAF   ubigeo
rename E PIM_total_2021
rename F PIM_total_2022
rename G PIM_total_2023

egen PIM_promedio_total_mean = rowmean(PIM_total_2021 PIM_total_2022 PIM_total_2023)

egen SUMA = rowtotal(PIM_total_2021 PIM_total_2022 PIM_total_2023)

gen PIM_promedio_total_all = SUMA/3

drop SUMA

keep  ubigeo PIM_total_2021 PIM_total_2022 PIM_total_2023 PIM_promedio_total_mean PIM_promedio_total_all
order ubigeo PIM_total_2021 PIM_total_2022 PIM_total_2023 PIM_promedio_total_mean PIM_promedio_total_all

unique ubigeo

save "$Output\PIM promedio total - DISTRITO.dta", replace

* PROVINCIA

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v3.xlsx", sheet("PIM PROV") firstrow clear cellrange(A2:G198)

rename UBIGEO_SIAF ubigeo
rename E           PIM_total_2021
rename F           PIM_total_2022
rename G           PIM_total_2023

gen ubigeo_pro = substr(ubigeo,1,4)

egen PIM_promedio_total_mean = rowmean(PIM_total_2021 PIM_total_2022 PIM_total_2023)

egen SUMA = rowtotal(PIM_total_2021 PIM_total_2022 PIM_total_2023)

gen PIM_promedio_total_all = SUMA/3

keep  ubigeo_pro PIM_total_2021 PIM_total_2022 PIM_total_2023 PIM_promedio_total_mean PIM_promedio_total_all
order ubigeo_pro PIM_total_2021 PIM_total_2022 PIM_total_2023 PIM_promedio_total_mean PIM_promedio_total_all

unique ubigeo

save "$Output\PIM promedio total - PROVINCIA.dta", replace

* REGIÒN

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v3.xlsx", sheet("PIM REG") firstrow clear cellrange(A1:F1763)

rename UBIGEO_SIAF ubigeo
rename D           PIM_total_2021
rename E           PIM_total_2022
rename F           PIM_total_2023

gen ubigeo_reg = substr(ubigeo,1,2)
gen ubigeo_pro = substr(ubigeo,1,4)

br if substr(ubigeo,1,2)=="15"
sort ubigeo_pro

replace ubigeo_reg = "26" if substr(ubigeo,1,2)=="15" & substr(ubigeo,1,4)!="1501"

collapse (sum) PIM_total_2021 PIM_total_2022 PIM_total_2023, by(ubigeo_reg DEPARTAMENTO)
	
egen PIM_promedio_total_mean = rowmean(PIM_total_2021 PIM_total_2022 PIM_total_2023)

egen SUMA = rowtotal(PIM_total_2021 PIM_total_2022 PIM_total_2023)

gen PIM_promedio_total_all = SUMA/3

keep  ubigeo_reg PIM_total_2021 PIM_total_2022 PIM_total_2023 PIM_promedio_total_mean PIM_promedio_total_all
order ubigeo_reg PIM_total_2021 PIM_total_2022 PIM_total_2023 PIM_promedio_total_mean PIM_promedio_total_all

unique ubigeo

save "$Output\PIM promedio total - REGIÒN.dta", replace

********************************************************************************
********************************************************************************
* PIM promedio de inversiones cuya función es subvencionada por el FIDT
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v2.xlsx", sheet("PIM FUNCION FIDT") firstrow clear cellrange(A6:G1896)

rename UBIGEO_SIAF   ubigeo
rename E PIM_FIDT_2021
rename F PIM_FIDT_2022
rename G PIM_FIDT_2023

egen PIM_promedio_FIDT_mean = rowmean(PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023)

egen SUMA = rowtotal(PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023)

gen PIM_promedio_FIDT_all = SUMA/3

drop SUMA

keep  ubigeo PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023 PIM_promedio_FIDT_mean PIM_promedio_FIDT_all
order ubigeo PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023 PIM_promedio_FIDT_mean PIM_promedio_FIDT_all

unique ubigeo

save "$Output\PIM promedio FIDT - DISTRITO.dta", replace

* PROVINCIA

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v3.xlsx", sheet("PIM PROV") firstrow clear cellrange(A2:G198)

rename UBIGEO_SIAF ubigeo
rename E           PIM_FIDT_2021
rename F           PIM_FIDT_2022
rename G           PIM_FIDT_2023

gen ubigeo_pro = substr(ubigeo,1,4)

egen PIM_promedio_FIDT_mean = rowmean(PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023)

egen SUMA = rowtotal(PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023)

gen PIM_promedio_FIDT_all = SUMA/3

keep  ubigeo_pro PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023 PIM_promedio_FIDT_mean PIM_promedio_FIDT_all
order ubigeo_pro PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023 PIM_promedio_FIDT_mean PIM_promedio_FIDT_all

unique ubigeo

save "$Output\PIM promedio FIDT - PROVINCIA.dta", replace

* REGIÒN

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v3.xlsx", sheet("FIDT REG") firstrow clear cellrange(A2:F1690)

rename UBIGEO_SIAF ubigeo
rename D           PIM_FIDT_2021
rename E           PIM_FIDT_2022
rename F           PIM_FIDT_2023

gen ubigeo_reg = substr(ubigeo,1,2)
gen ubigeo_pro = substr(ubigeo,1,4)

br if substr(ubigeo,1,2)=="15"
sort ubigeo_pro

replace ubigeo_reg = "26" if substr(ubigeo,1,2)=="15" & substr(ubigeo,1,4)!="1501"

collapse (sum) PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023, by(ubigeo_reg DEPARTAMENTO)

egen PIM_promedio_FIDT_mean = rowmean(PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023)

egen SUMA = rowtotal(PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023)

gen PIM_promedio_FIDT_all = SUMA/3

keep  ubigeo_reg PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023 PIM_promedio_FIDT_mean PIM_promedio_FIDT_all
order ubigeo_reg PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023 PIM_promedio_FIDT_mean PIM_promedio_FIDT_all

unique ubigeo

save "$Output\PIM promedio FIDT - REGIÒN.dta", replace

********************************************************************************
********************************************************************************
* PIM promedio por donaciones y Transferencia
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v2.xlsx", sheet("PIM DONACIONES") firstrow clear cellrange(A6:G1279)

rename UBIGEO_SIAF   ubigeo
rename E PIM_donaciones_2021
rename F PIM_donaciones_2022
rename G PIM_donaciones_2023

egen PIM_promedio_donaciones_mean = rowmean(PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023)

egen SUMA = rowtotal(PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023)

gen PIM_promedio_donaciones_all = SUMA/3

drop SUMA

keep  ubigeo PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023 PIM_promedio_donaciones_mean PIM_promedio_donaciones_all
order ubigeo PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023 PIM_promedio_donaciones_mean PIM_promedio_donaciones_all

unique ubigeo

save "$Output\PIM promedio donaciones y Transferencia - DISTRITO.dta", replace

* PROVINCIA

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v3.xlsx", sheet("DON PROV") firstrow clear cellrange(A2:G149)

rename UBIGEO_SIAF ubigeo
rename E           PIM_donaciones_2021
rename F           PIM_donaciones_2022
rename G           PIM_donaciones_2023

gen ubigeo_pro = substr(ubigeo,1,4)

egen PIM_promedio_donaciones_mean = rowmean(PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023)

egen SUMA = rowtotal(PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023)

gen PIM_promedio_donaciones_all = SUMA/3

keep  ubigeo_pro PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023 PIM_promedio_donaciones_mean PIM_promedio_donaciones_all
order ubigeo_pro PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023 PIM_promedio_donaciones_mean PIM_promedio_donaciones_all

unique ubigeo_pro

save "$Output\PIM promedio donaciones y Transferencia - PROVINCIA.dta", replace

* REGIÒN

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v3.xlsx", sheet("DON REG") firstrow clear cellrange(A2:G156)

rename UBIGEO_SIAF ubigeo
rename E           PIM_donaciones_2021
rename F           PIM_donaciones_2022
rename G           PIM_donaciones_2023

gen ubigeo_reg = substr(ubigeo,1,2)
gen ubigeo_pro = substr(ubigeo,1,4)

br if substr(ubigeo,1,2)=="15"
sort ubigeo_pro

replace ubigeo_reg = "26" if substr(ubigeo,1,2)=="15" & substr(ubigeo,1,4)!="1501"

collapse (sum) PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023, by(ubigeo_reg)

egen PIM_promedio_donaciones_mean = rowmean(PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023)

egen SUMA = rowtotal(PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023)

gen PIM_promedio_donaciones_all = SUMA/3

keep  ubigeo_reg PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023 PIM_promedio_donaciones_mean PIM_promedio_donaciones_all
order ubigeo_reg PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023 PIM_promedio_donaciones_mean PIM_promedio_donaciones_all

unique ubigeo

save "$Output\PIM promedio donaciones y Transferencia - REGIÒN.dta", replace

********************************************************************************
********************************************************************************

use "$Ubigeo\UBIGEO 2022.dta", clear
merge 1:1 ubigeo using "$Output\PIM promedio total - DISTRITO.dta", nogen
merge 1:1 ubigeo using "$Output\PIM promedio FIDT - DISTRITO.dta", nogen
merge 1:1 ubigeo using "$Output\PIM promedio donaciones y Transferencia - DISTRITO.dta", nogen

br if inlist(ubigeo, "030612", "050413", "050512", "050513", "050514", "050515", "080915", "080916", "080917") // 9 distritos 
br if inlist(ubigeo, "080918", "090724", "090725", "130112", "160109", "180107", "221006", "250306", "250307") // 9 distritos

mdesc

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\10. Recursos Presupuestales distrito_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\10. Recursos Presupuestales distrito.dta", replace

********************************************************************************
********************************************************************************

use "$Ubigeo\UBIGEO 2022.dta", clear

gen ubigeo_pro = substr(ubigeo,1,4)

keep  ubigeo_pro REGION PROVINCIA
order ubigeo_pro REGION PROVINCIA

duplicates drop

merge 1:1 ubigeo_pro using "$Output\PIM promedio total - PROVINCIA.dta", nogen
merge 1:1 ubigeo_pro using "$Output\PIM promedio FIDT - PROVINCIA.dta", nogen
merge 1:1 ubigeo_pro using "$Output\PIM promedio donaciones y Transferencia - PROVINCIA.dta", nogen

mdesc

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\10. Recursos Presupuestales provincia_all.dta", replace

drop REGION PROVINCIA

save "$Output\10. Recursos Presupuestales provincia.dta", replace

********************************************************************************
********************************************************************************

use "$Ubigeo\UBIGEO 2022.dta", clear

gen ubigeo_reg = substr(ubigeo,1,2)

replace REGION="15 Lima Provincias"    if substr(ubigeo,1,2)=="15" & PROVINCIA=="01 Lima"

replace REGION="26 Lima Metropolitana" if substr(ubigeo,1,2)=="15" & PROVINCIA!="01 Lima"
replace ubigeo_reg="26"                if substr(ubigeo,1,2)=="15" & PROVINCIA!="01 Lima"

keep  ubigeo_reg REGION
order ubigeo_reg REGION

duplicates drop

merge 1:1 ubigeo_reg using "$Output\PIM promedio total - REGIÒN.dta", nogen
merge 1:1 ubigeo_reg using "$Output\PIM promedio donaciones y Transferencia - REGIÒN.dta", nogen
merge 1:1 ubigeo_reg using "$Output\PIM promedio FIDT - REGIÒN.dta", nogen

mdesc

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\10. Recursos Presupuestales region_all.dta", replace

drop REGION 

save "$Output\10. Recursos Presupuestales region.dta", replace

/*
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




