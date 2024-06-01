* Tema: Electrificación rural
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path            = "E:\01. DataBase\FIDT"
global Ubigeo          = "$Path\00. Ubigeo"
global Censo_2017      = "$Path\01. Censo 2017"
global Output          = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\06. Electrificación rural"

********************************************************************************
********************************************************************************
* Porcentaje de viviendas rurales sin electricidad
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Censo_2017\INFORMACION MEF REG. 7922.xlsx", sheet("ELECT_DIST") clear cellrange(B9:L1899)

rename B ubigeo	
rename C Distrito
rename D Total
rename E Con_electricidad
rename F Sin_electricidad
rename G Total_urbano
rename H Con_electricidad_urbano
rename I Sin_electricidad_urbano
rename J Total_rural
rename K Con_electricidad_rural
rename L Sin_electricidad_rural

gen P_Sin_electricidad_rural = Sin_electricidad_rural / Total_rural

replace P_Sin_electricidad_rural=0 if Sin_electricidad_rural==0 & Total_rural==0

keep ubigeo P_Sin_electricidad_rural

save "$Output\Sin electricidad rural.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje de población rural
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Censo_2017\INFORMACION MEF REG. 7922.xlsx", sheet("SEGURO_DIST") clear cellrange(B8:O1898)

rename B ubigeo	
rename C Distrito
rename D Total
rename E Sin_seguro
rename F Con_seguro
rename G Con_más_un_seguro
rename H Total_urbano
rename I Sin_seguro_urbano
rename J Con_seguro_urbano
rename K Con_más_un_seguro_urbano
rename L Total_rural
rename M Sin_seguro_rural
rename N Con_seguro_rural
rename O Con_más_un_seguro_rural

gen P_Población_rural = Total_rural / Total

keep ubigeo P_Población_rural

save "$Output\Población rural.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************

use "$Ubigeo\UBIGEO 2022.dta", clear

merge 1:1 ubigeo using "$Output\Sin electricidad rural.dta", nogen
merge 1:1 ubigeo using "$Output\Población rural.dta", nogen

mdesc
/*
    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
         ubigeo |           0          1,891           0.00
         REGION |           0          1,891           0.00
      PROVINCIA |           0          1,891           0.00
       DISTRITO |           0          1,891           0.00
   P_Sin_elec~l |           0          1,891           0.00
   Población_~l |           0          1,891           0.00
----------------+-----------------------------------------------
*/

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\06. Electrificación rural_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\06. Electrificación rural.dta", replace
