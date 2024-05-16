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

global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\02. Desnutrición infantil yo anemia infantil"

********************************************************************************
********************************************************************************
* Porcentaje de desnutrición crónica en niños menores de 5 años
********************************************************************************
********************************************************************************

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

use ubigeo Desnutricion_cromica using "$Output\Desnutrición.dta", clear
merge 1:1 ubigeo using "$Output\Anemia.dta", keepusing(Anemia_total) nogen
save "$Output\02 Desnutrición infantil yo anemia infantil.dta", replace
