* Códificación de ubigeo 2022
* Elaboracion: Carlos Torres 
********************************************************************************

clear all
set more off 

cd "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\00. Dataset\00. Ubigeo\"

********************************************************************************

import excel "rptUbigeo.xls", sheet("ubicacionGeografica") firstrow clear

keep B E F
rename B REGION
rename E PROVINCIA
rename F DISTRITO

drop if REGION=="" & PROVINCIA=="" & DISTRITO==""
drop if REGION=="DEPARTAMENTO" & PROVINCIA=="PROVINCIA" & DISTRITO=="DISTRITO"
drop if DISTRITO==" "

foreach VAR of varlist REGION PROVINCIA DISTRITO {
	replace `VAR'=stritrim(`VAR') // centro
	replace `VAR'=strtrim(`VAR')  // lados
}

gen ubigeo = substr(REGION,1,2) + substr(PROVINCIA,1,2) + substr(DISTRITO,1,2)

order ubigeo REGION PROVINCIA DISTRITO

save "UBIGEO 2022.dta", replace
