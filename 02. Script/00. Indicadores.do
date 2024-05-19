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
global Desnutrición            = "$Input\02. Desnutrición infantil yo anemia infantil"
global Educación               = "$Input\03. Servicios de educación básica"
global Infraestructura         = "$Input\04. Infraestructura vial"
global Saneamiento             = "$Input\05. Servicio de Saneamiento"
global Electrificación         = "$Input\06. Electrificación rural"
global Telecomunicación        = "$Input\08. Telecomunicación rural"
global Desarrollo_Productivo   = "$Input\09. Apoyo al desarrollo productivo"
global Recursos_Presupuestales = "$Input\10. Recursos Presupuestales"
global Pobreza                 = "$Input\11. Pobreza"
global Output                  = "$Path\03. Output"

* Data Warehouse
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Salud\01. Salud Básica.dta", clear
merge 1:1 ubigeo using "$Desnutrición\02. Desnutrición infantil yo anemia infantil.dta", nogen
merge 1:1 ubigeo using "$Educación\03.1 Servicios de educación básica.dta", nogen
merge 1:1 ubigeo using "$Educación\03.2 Servicios de educación básica.dta", nogen
merge 1:1 ubigeo using "$Saneamiento\05. Vivienda y saneamiento.dta", nogen
merge 1:1 ubigeo using "$Electrificación\06. Electrificación rural.dta", keepusing(Sin_electricidad_rural P_Población_rural) nogen
merge 1:1 ubigeo using "$Telecomunicación\08. Telecomunicación rural.dta", keepusing(Sin_teléfono_celular_rural Sin_teléfono_fijo_rural Sin_conexión_internet_rural Cobertura_inter_fijo_dummy_rur Cobertura_inter_movil_dummy_rur) nogen
merge 1:1 ubigeo using "$Desarrollo_Productivo\09. Apoyo al desarrollo productivo.dta", nogen
merge 1:1 ubigeo using "$Recursos_Presupuestales\10. Recursos Presupuestales.dta", nogen
merge 1:1 ubigeo using "$Pobreza\11. Pobreza monetaria 2018.dta", nogen

merge 1:1 ubigeo using "$Saneamiento\05. Vivienda y saneamiento.dta", keepusing(ubigeo) keep(3) nogen

* Rename vars.
*'''''''''''''
rename Establecimientos_salud_SP       v01_Establecimientos_salud_SP 
rename Con_discapacidad                v02_Con_discapacidad
rename Sin_seguro                      v03_Sin_seguro 
rename Desnutricion_cromica            v04_Desnutricion_cromica
rename Anemia_total                    v05_Anemia_total
rename No_leer_escribir                v06_No_leer_escribir 
rename Asiste_IE_otro_distrito         v07_Asiste_IE_otro_distrito 
rename Nivel_secundaria_más_17         v08_Nivel_secundaria_más_17
rename Schooling                       v09_Años_escolaridad
rename No_estudian_6_17                v10_No_estudian_6_17
rename P_aulas_bueno_regular           v12_P_aulas_bueno_regular
rename Sin_PC_Tablet_Laptop            v13_Sin_PC_Tablet_Laptop
*rename v14_
rename No_Registros_Públicos_LE        v15_No_Registros_Públicos_LE
rename No_paredes_aula_LE              v16_No_paredes_aula_LE
rename No_techo_aula_LE                v17_No_techo_aula_LE
rename No_piso_aula_LE                 v18_No_piso_aula_LE
rename Sin_agua_LE                     v19_Sin_agua_LE  
rename Sin_desagüe_LE                  v20_Sin_desagüe_LE
rename Sin_electricidad_LE             v21_Sin_electricidad_LE
rename No_servicio_eléctrico_LE        v22_No_servicio_eléctrico_LE
rename Cerco_perimétrico_total         v23_Cerco_perimétrico_total
rename Cerco_perimétrico_parcial       v23_Cerco_perimétrico_parcial
rename Cerco_perimétrico_no_tiene      v23_Cerco_perimétrico_no_tiene
rename Cantidad_LE                     v24_Cantidad_LE
*rename v25_
*rename v26_
*rename v27_
*rename v28_
*rename v29_
*rename v30_
*rename v31_
*rename v32_
*rename v33_

rename Sin_agua                        v34_Sin_agua
rename Sin_desagüe                     v35_Sin_desagüe
rename Sin_electricidad_rural          v36_Sin_electricidad_ruralE
rename P_Población_rural               v37_P_Población_rural
rename Sin_teléfono_celular_rural      v38_Sin_teléfono_celular_rural
rename Sin_teléfono_fijo_rural         v39_Sin_teléfono_fijo_rural
rename Sin_conexión_internet_rural     v40_Sin_conexión_internet_rural
rename Cobertura_inter_fijo_dummy_rur  v41_Cobertura_inter_fijo_rural
rename Cobertura_inter_movil_dummy_rur v41_Cobertura_inter_movil_rural
rename PEA_Agri_gana_silvi_pesca       v42_PEA_Agri_gana_silvi_pesca
rename Superficie_agrícola_ha          v43_Superficie_agrícola_ha
rename Superficie_territorial_ha       v43_Superficie_territorial_ha 
rename VBP_corriente_2023 		       v44_VBP_corriente_2023
rename Número_productores 		       v45_Número_productores
rename PIM_promedio                    v46_PIM_promedio
rename PIM_promedio_FIDT               v47_PIM_promedio_FIDT
rename PIM_promedio_donaciones         v48_PIM_promedio_donaciones
rename Ejecución_total                 v49_Ejecución_total
rename Ejecución_FIDT                  v50_Ejecución_FIDT
rename Ejecución_promedio_donaciones   v51_Ejecución_donaciones
rename Pobreza_monetaria               v52_Pobreza_monetaria


/*
label variable v01_Establecimientos_salud_SP  ""
label variable v02_Con_discapacidad  ""
label variable v03_Sin_seguro  ""
label variable v04_Desnutricion_cromica  ""
label variable v05_Anemia_total  ""
label variable v06_No_leer_escribir  ""
label variable v07_Asiste_IE_otro_distrito  ""
label variable v08_Nivel_secundaria_más_17  ""
label variable v09_Años_escolaridad  ""
label variable v10_No_estudian_6_17  ""
label variable v12_P_aulas_bueno_regular ""
label variable v13_Sin_PC_Tablet_Laptop  ""
label variable v15_No_Registros_Públicos_LE  ""
label variable v16_No_paredes_aula_LE  ""
label variable v17_No_techo_aula_LE  ""
label variable v18_No_piso_aula_LE  ""
label variable v19_Sin_agua_LE 
label variable v20_Sin_desagüe_LE 
label variable v21_Sin_electricidad_LE 
label variable v22_No_servicio_eléctrico_LE 
label variable v23_Cerco_perimétrico_total 
label variable v23_Cerco_perimétrico_parcial 
label variable v23_Cerco_perimétrico_no_tiene 
label variable v24_Cantidad_LE  "" 
label variable v34_Sin_agua "" 
label variable v35_Sin_desagüe "" 
label variable v36_Sin_electricidad_ruralE 
label variable v37_P_Población_rural "" 
label variable v38_Sin_teléfono_celular_rural "" 
label variable v39_Sin_teléfono_fijo_rural "" 
label variable v40_Sin_conexión_internet_rural "" 
label variable v41_Cobertura_inter_fijo_rural "" 
label variable v41_Cobertura_inter_movil_rural "" 
label variable v42_PEA_Agri_gana_silvi_pesca v43_Superficie_agrícola_ha v43_Superficie_territorial_ha "" 
label variable v44_VBP_corriente_2023 v45_Número_productores 
label variable v46_PIM_promedio v47_PIM_promedio_FIDT v48_PIM_promedio_donaciones v49_Ejecución_total v50_Ejecución_FIDT ""
label variable v51_Ejecución_donaciones v52_Pobreza_monetaria ""
*/


save "$Input\Data_Warehouse.dta", replace
save "$Path\Data_Warehouse.dta", replace
