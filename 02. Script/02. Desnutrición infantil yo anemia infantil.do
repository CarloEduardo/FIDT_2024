* Tema: Desnutrición infantil yo anemia infantil
* Elaboracion: Carlos Torres
* Link: 
* https://observateperu.ins.gob.pe/
* 
* Situación nutricional de niños menores de 05 años
* https://www.minsa.gob.pe/reunis/data/sien-hisminsa-5.asp
* https://www.gob.pe/institucion/ins/informes-publicaciones/4201302-indicadores-ninos-enero-diciembre-2022-base-de-datos-his-minsa

* Situación nutricional de las gestantes
* https://www.minsa.gob.pe/reunis/data/sien-hisminsa-estado-nuticional-gestantes.asp
* https://www.gob.pe/institucion/ins/informes-publicaciones/4201301-indicadores-gestantes-enero-diciembre-2022-base-de-datos-sien
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Ubigeo = "E:\01. DataBase\1. INEI\4 SISCONCODE\01. UBIGEO 2022"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\02. Desnutrición infantil yo anemia infantil"

********************************************************************************
********************************************************************************
* Porcentaje de desnutrición crónica en niños menores de 5 años
********************************************************************************
********************************************************************************
/*
Con esta variable podremos conocer el porcentaje de la población de niños menores de 5 años con desnutrición crónica, y que necesitan infraestructura en salud adecuada para un correcto tratamiento.
*/

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Output\Indicadores Niños Enero – Diciembre 2022 (Base de Datos HIS-Minsa).xlsx", sheet("EN 0-59m x DISTRITO") firstrow clear

rename (E F G) (ubigeo Población_evaluados Población_desnutricion_cromica)
keep ubigeo Población_evaluados Población_desnutricion_cromica

* Filtering data
*'''''''''''''''
drop if ubigeo=="UBIGEO" & Población_evaluados=="INDICADOR TALLA / EDAD1" & Población_desnutricion_cromica==""
drop if ubigeo=="" & Población_evaluados=="" & Población_desnutricion_cromica==""
drop if ubigeo==""

destring Población_evaluados, replace
destring Población_desnutricion_cromica, replace

gen Desnutricion_cromica=Población_desnutricion_cromica/Población_evaluados

save "$Output\Desnutrición.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje de anemia total en niños entre 6 y 35 meses
********************************************************************************
********************************************************************************
/*
Con esta variable podremos conocer el porcentaje de la población de niños entre 6 y 35 meses, y que necesitan infraestructura en salud adecuada para un correcto tratamiento.
*/

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Output\Indicadores Niños Enero – Diciembre 2022 (Base de Datos HIS-Minsa).xlsx", sheet("Anemia 6-35m x DISTRITO") firstrow clear

rename (E F G) (ubigeo Población_evaluados Población_anemia_total)
keep ubigeo Población_evaluados Población_anemia_total

* Filtering data
*'''''''''''''''
drop if ubigeo=="UBIGEO" & Población_evaluados=="N° DE EVALUADOS" & Población_anemia_total=="ANEMIA TOTAL"
drop if ubigeo=="" & Población_evaluados=="" & Población_anemia_total==""
drop if ubigeo==""

destring Población_evaluados, replace
destring Población_anemia_total, replace

gen Anemia_total=Población_anemia_total/Población_evaluados

save "$Output\Anemia.dta", replace

*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Ubigeo\UBIGEO 2022.dta", clear

merge 1:1 ubigeo using "$Output\Desnutrición.dta", keepusing(Desnutricion_cromica) nogen
merge 1:1 ubigeo using "$Output\Anemia.dta", keepusing(Anemia_total) nogen

* Imputation at the provincial level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
mdesc

gen id_reg_prov = substr(ubigeo,1,4)

bys id_reg_prov: egen Desnutricion_cromica_ip = mean(Desnutricion_cromica)
bys id_reg_prov: egen Anemia_total_ip         = mean(Anemia_total)

replace Desnutricion_cromica  = Desnutricion_cromica_ip  if Desnutricion_cromica==.
replace Anemia_total          = Anemia_total_ip          if Anemia_total==.

drop id_reg_prov Desnutricion_cromica_ip Anemia_total_ip

mdesc

/*
* Imputation at the regional level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
mdesc

gen id_reg = substr(ubigeo,1,2)

bys id_reg: egen Establecimientos_salud_SP_ir = mean(Establecimientos_salud_SP)
bys id_reg: egen Con_discapacidad_ir          = mean(Con_discapacidad)
bys id_reg: egen Sin_seguro_ir                = mean(Sin_seguro)

replace Con_discapacidad = Con_discapacidad_ir if Con_discapacidad==.
replace Sin_seguro       = Sin_seguro_ir       if Sin_seguro==.

drop id_reg Con_discapacidad_ir Sin_seguro_ir

mdesc
*/

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\02 Desnutrición infantil yo anemia infantil_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\02 Desnutrición infantil yo anemia infantil.dta", replace

