* Tema: Apoyo al desarrollo productivo
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
********************************************************************************
global Path      = "E:\01. DataBase\FIDT"
global InvertePe = "$Path\INVIERTE.PE"
global Output    = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\04. Infraestructura vial"

********************************************************************************
********************************************************************************
* Porcentaje red vial departamental en condiciones inadecuadas
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$InvertePe\DASSHBOARDRED.xlsx", sheet("Exportar Hoja de Trabajo") firstrow clear

rename UBIGEO ubigeo 

* Filtering data
*'''''''''''''''
keep if INDICADOR_ANIO==2023
keep if INDICADOR=="PORCENTAJE DE LA RED VIAL NACIONAL EN CONDICIONES INADECUADAS"
drop if NIVEL=="PAIS" & DEPARTAMENTO=="PAIS"

rename INDICADOR_VALOR Red_vial_regional_inadecuadas

gen reg = substr(ubigeo,1,2)

keep  ubigeo reg Red_vial_regional_inadecuadas
order ubigeo reg Red_vial_regional_inadecuadas

save "$Output\Red vial departamental en condiciones inadecuadas.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje red vial departamental por implementar
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$InvertePe\DASSHBOARDRED.xlsx", sheet("Exportar Hoja de Trabajo") firstrow clear

rename UBIGEO ubigeo 

* Filtering data
*'''''''''''''''
keep if INDICADOR_ANIO==2023
keep if INDICADOR=="PORCENTAJE DE LA RED VIAL DEPARTAMENTAL POR IMPLEMENTAR"
drop if PROVINCIA==""

rename INDICADOR_VALOR Red_vial_regional_implementar

gen pro = substr(ubigeo,1,4)

keep  ubigeo pro Red_vial_regional_implementar
order ubigeo pro Red_vial_regional_implementar

save "$Output\Red vial departamental por implementar.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje red vial nacional en condiciones inadecuadas
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$InvertePe\DASSHBOARDRED.xlsx", sheet("Exportar Hoja de Trabajo") firstrow clear

rename UBIGEO ubigeo 

* Filtering data
*'''''''''''''''
keep if INDICADOR_ANIO==2023
keep if INDICADOR=="PORCENTAJE DE LA RED VIAL NACIONAL EN CONDICIONES INADECUADAS"
drop if NIVEL=="PAIS" & DEPARTAMENTO=="PAIS"

rename INDICADOR_VALOR Red_vial_nacional_inadecuadas

gen reg = substr(ubigeo,1,2)

keep  ubigeo reg Red_vial_nacional_inadecuadas
order ubigeo reg Red_vial_nacional_inadecuadas

save "$Output\Red vial nacional en condiciones inadecuadas.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje red vial nacional por implementar
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$InvertePe\DASSHBOARDRED.xlsx", sheet("Exportar Hoja de Trabajo") firstrow clear

rename UBIGEO ubigeo 

* Filtering data
*'''''''''''''''
keep if INDICADOR_ANIO==2023
keep if INDICADOR=="PORCENTAJE DE LA RED VIAL NACIONAL POR IMPLEMENTAR"
drop if NIVEL=="PAIS" & DEPARTAMENTO=="PAIS"

rename INDICADOR_VALOR Red_vial_nacional_implementar

gen reg = substr(ubigeo,1,2)

keep  ubigeo reg Red_vial_nacional_implementar
order ubigeo reg Red_vial_nacional_implementar

save "$Output\Red vial nacional por implementar.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje red vial vecinal en condiciones inadecuadas
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$InvertePe\DASSHBOARDRED.xlsx", sheet("Exportar Hoja de Trabajo") firstrow clear

rename UBIGEO ubigeo 

* Filtering data
*'''''''''''''''
keep if INDICADOR_ANIO==2023
keep if INDICADOR=="PORCENTAJE DE LA RED VIAL VECINAL EN CONDICIONES INADECUADAS"
drop if PROVINCIA==""

gen pro = substr(ubigeo,1,4)

rename INDICADOR_VALOR Red_vial_vecinal_inadecuadas

keep ubigeo pro Red_vial_vecinal_inadecuadas
keep ubigeo pro Red_vial_vecinal_inadecuadas

save "$Output\Red vial vecinal en condiciones inadecuadas.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje red vial vecinal por implementar
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$InvertePe\DASSHBOARDRED.xlsx", sheet("Exportar Hoja de Trabajo") firstrow clear

rename UBIGEO ubigeo 

* Filtering data
*'''''''''''''''
keep if INDICADOR_ANIO==2023
keep if INDICADOR=="PORCENTAJE DE LA RED VIAL NACIONAL POR IMPLEMENTAR"
drop if NIVEL=="PAIS" & DEPARTAMENTO=="PAIS"

gen reg = substr(ubigeo,1,2)

rename INDICADOR_VALOR Red_vial_vecinal_implementar

keep  ubigeo reg Red_vial_vecinal_implementar
order ubigeo reg Red_vial_vecinal_implementar

save "$Output\Red vial vecinal por implementar.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************

use "$Ubigeo\UBIGEO 2022.dta", clear

gen reg = substr(ubigeo,1,2)
gen pro = substr(ubigeo,1,4)

merge m:1 reg using "$Output\Red vial departamental en condiciones inadecuadas.dta", nogen
merge m:1 pro using "$Output\Red vial departamental por implementar.dta", nogen
merge m:1 reg using "$Output\Red vial nacional en condiciones inadecuadas.dta", nogen
merge m:1 reg using "$Output\Red vial nacional por implementar.dta", nogen
merge m:1 pro using "$Output\Red vial vecinal en condiciones inadecuadas.dta", nogen
merge m:1 reg using "$Output\Red vial vecinal por implementar.dta", nogen

keep  ubigeo REGION PROVINCIA DISTRITO Red_vial_regional_inadecuadas Red_vial_regional_implementar Red_vial_nacional_inadecuadas Red_vial_nacional_implementar Red_vial_vecinal_inadecuadas Red_vial_vecinal_implementar
order ubigeo REGION PROVINCIA DISTRITO Red_vial_regional_inadecuadas Red_vial_regional_implementar Red_vial_nacional_inadecuadas Red_vial_nacional_implementar Red_vial_vecinal_inadecuadas Red_vial_vecinal_implementar

mdesc
/*
   Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
         ubigeo |           0          1,891           0.00
   Red_vial_r~s |           0          1,891           0.00
   Red_vial_r~r |         143          1,891           7.56
   Red_vial_n~s |           0          1,891           0.00
   Red_vial_n~r |           0          1,891           0.00
   Red_vial_v~s |          27          1,891           1.43
   Red_vial_v~r |           0          1,891           0.00
----------------+-----------------------------------------------

*/

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\04. Infraestructura vial_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\04. Infraestructura vial.dta", replace

