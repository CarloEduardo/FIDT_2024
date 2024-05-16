* Tema: Indicadores FIDT
* Elaboracion: Carlos Torres: 
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path                    = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024"
global Input                   = "$Path\01. Input"
global Salud                   = "$Input\01. Salud Básica"
global Desnutrición        	   = "$Input\02. Desnutrición infantil yo anemia infantil"
global Educación               = "$Input\03. Servicios de educación básica"
global Infraestructura         = "$Input\04. Infraestructura vial"
global Saneamiento             = "$Input\05. Servicio de Saneamiento"
global Electrificación         = "$Input\06. Electrificación rural"
global Telecomunicación        = "$Input\08. Telecomunicación rural"
global Desarrollo_Productivo   = "$Input\09. Apoyo al desarrollo productivo"
global Recursos_Presupuestales = "$Input\10. Recursos Presupuestales"
global Output                  = "$Path\03. Output"

* Data Warehouse
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Salud\01 Salud Básica.dta", clear
merge 1:1 ubigeo using "$Desnutrición\02 Desnutrición infantil yo anemia infantil", nogen
merge 1:1 ubigeo using "$Educación\03 Servicios de educación básica", nogen
merge 1:1 ubigeo using "$Saneamiento\05 Vivienda y saneamiento", nogen
merge 1:1 ubigeo using "$Electrificación\06 Electrificación rural", nogen
merge 1:1 ubigeo using "$Telecomunicación\08 Telecomunicación rural", nogen
merge 1:1 ubigeo using "$Desarrollo_Productivo\09 Apoyo al desarrollo productivo.dta", nogen

* Rename vars.
*'''''''''''''
rename Establecimientos_salud_SP v01_Establecimientos_salud_SP 
rename Con_discapacidad          v02_Con_discapacidad
rename Sin_seguro                v03_Sin_seguro 
rename Desnutricion_cromica      v04_Desnutricion_cromica
rename Anemia_total              v05_Anemia_total
rename No_leer_escribir          v06_No_leer_escribir 
rename Asiste_IE_otro_distrito   v07_Asiste_IE_otro_distrito 
rename Nivel_secundaria_más_17   v08_Nivel_secundaria_más_17
rename v9
rename v11_
rename v12_
rename v13_
rename v14_
rename v15_
rename v16_
rename v17_
rename v18_
rename v19_
rename v20_
rename v21_
rename v22_
rename v23_
rename v24_
rename v25_
rename v26_
rename v27_
rename v28_
rename v29_
rename v30_
rename  v31_
rename  v32_
rename  v33_
rename  v34_
rename  v35_
rename  v36_
rename  v37_
rename  v38_
rename  v39_
rename  v40_
rename  v41_
rename  v42_
rename Superficie_agrícola_ha    v43_Superficie_agrícola_ha
rename Superficie_territorial_ha v43_Superficie_territorial_ha 
rename VBP_corriente_2023 		 v44_VBP_corriente_2023
rename Número_productores 		 v45_Número_productores


save "$Input\Data_Warehouse.dta", replace