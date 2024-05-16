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
********************************************************************************

global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT\01. Input\02. Desnutrición infantil yo anemia infantil"

* Importing database
********************************************************************************

import excel "$Output\Indicadores Niños Enero – Diciembre 2022 (Base de Datos HIS-Minsa).xlsx", sheet("Anemia 6-35m x DISTRITO") firstrow clear

rename (E F G) (ubigeo N_evaluados anemia)
keep ubigeo N_evaluados anemia

* Filtering data
****************
drop if ubigeo=="UBIGEO" & N_evaluados=="N° DE EVALUADOS" & anemia=="ANEMIA TOTAL"
drop if ubigeo=="" & N_evaluados=="" & anemia==""
drop if ubigeo==""

destring N_evaluados, replace
destring anemia, replace

gen porc_anemia=anemia/N_evaluados

save "$Output\Anemia.dta", replace

* Importing database
********************************************************************************

import excel "$Output\Indicadores Niños Enero – Diciembre 2022 (Base de Datos HIS-Minsa).xlsx", sheet("EN 0-59m x DISTRITO") firstrow clear

rename (E F G) (ubigeo N_evaluados desnutricion_cromica)
keep ubigeo N_evaluados desnutricion_cromica

* Filtering data
****************
drop if ubigeo=="UBIGEO" & N_evaluados=="INDICADOR TALLA / EDAD1" & desnutricion_cromica==""
drop if ubigeo=="" & N_evaluados=="" & desnutricion_cromica==""
drop if ubigeo==""

destring N_evaluados, replace
destring desnutricion_cromica, replace

gen porc_desnutricion_cromica=desnutricion_cromica/N_evaluados

save "$Output\Desnutrición crómica.dta", replace

********************************************************************************

use ubigeo porc_anemia using "$Output\Anemia.dta", clear
merge 1:1 ubigeo using "$Output\Desnutrición crómica.dta", keepusing(porc_desnutricion_cromica) nogen
save "$Output\Desnutrición infantil yo anemia infantil.dta", replace
