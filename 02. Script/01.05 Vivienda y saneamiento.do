clear all
set more off

********************************************************************************
* Tema: Vivienda y saneamiento
* Elaboracion: Carlos Torres
********************************************************************************

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path       = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024"
global Ubigeo     = "$Path\01. Input\00. Dataset\00. Ubigeo"
*global Censo_2017 = "$Path\01. Input\00. Dataset\01. Censo 2017"
global Censo_2017 = "E:\01. DataBase\FIDT\01. Censo 2017" // Debido al peso, los archivos del Censo no se subieron a GitHub
global Output     = "$Path\01. Input\05. Servicio de Saneamiento"

********************************************************************************
********************************************************************************
* Porcentaje de viviendas sin agua seguro 
********************************************************************************
********************************************************************************		

import excel "$Censo_2017\INFORMACION MEF REG. 7922.xlsx", sheet("AGUA_DIST") clear cellrange(B9:AG1899)

rename B ubigeo	
rename C Distrito
rename D Total
rename E Red_pública_dentro
rename F Red_pública_fuera
rename G Pilón_pileta
rename H Camión_cisterna
rename I Pozo
rename J Manantial_puquio
rename K Río_acequia_lago_laguna
rename L Otro
rename M Vecino

replace Red_pública_dentro="0" if Red_pública_dentro=="-"
replace Red_pública_fuera="0"  if Red_pública_fuera=="-"
replace Pilón_pileta="0"       if Pilón_pileta=="-"

destring Red_pública_dentro, replace
destring Red_pública_fuera, replace
destring Pilón_pileta, replace

mdesc Red_pública_dentro Red_pública_fuera Pilón_pileta Total
/*
    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   Red_públic~o |           0          1,891           0.00
   Red_públic~a |           0          1,891           0.00
   Pilón_pileta |           0          1,891           0.00
          Total |           0          1,891           0.00
----------------+-----------------------------------------------
*/

gen P_Sin_agua = 1 - (Red_pública_dentro + Red_pública_fuera + Pilón_pileta)/Total

keep ubigeo P_Sin_agua

save "$Output\Sin agua.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje de viviendas sin desagüe de red pública
********************************************************************************
********************************************************************************		

import excel "$Censo_2017\INFORMACION MEF REG. 7922.xlsx", sheet("SERV_HIGIENICO_DIST") clear cellrange(B9:AD1899)

rename B ubigeo	
rename C Distrito
rename D Total
rename E Red_pública_desagüe_dentro
rename F Red_pública_desagüe_fuera
rename G Pozo_séptico
rename H Letrina
rename I Pozo_ciego_negro
rename J Río_acequia_canal_similar
rename K Campo_abierto_al_aire_libre
rename L Otro

mdesc Red_pública_desagüe_dentro Total
/*
    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   Red_públic~o |           0          1,891           0.00
          Total |           0          1,891           0.00
----------------+-----------------------------------------------
*/

gen P_Sin_desagüe = 1 - (Red_pública_desagüe_dentro)/Total

keep ubigeo P_Sin_desagüe

save "$Output\Sin desagüe.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************

* Merging datasets
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Ubigeo\UBIGEO 2022.dta", clear
merge 1:1 ubigeo using "$Output\Sin agua.dta", nogen
merge 1:1 ubigeo using "$Output\Sin desagüe.dta", nogen

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\05. Saneamiento_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\05. Saneamiento.dta", replace
