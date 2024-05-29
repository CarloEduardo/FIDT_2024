* Tema: Indicadores FIDT
* Elaboracion: Carlos Torres: 
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path                    = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024"
global Ubigeo                  = "E:\01. DataBase\FIDT\00. Ubigeo"
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

use "$Ubigeo\UBIGEO 2022.dta", clear
merge 1:1 ubigeo using "$Salud\01. Salud Básica.dta", nogen
merge 1:1 ubigeo using "$Desnutrición\02. Desnutrición infantil yo anemia infantil.dta", nogen
merge 1:1 ubigeo using "$Educación\03.1 Servicios de educación básica.dta", nogen
merge 1:1 ubigeo using "$Educación\03.2 Servicios de educación básica.dta", nogen
merge 1:1 ubigeo using "$Infraestructura\04. Infraestructura vial.dta", nogen
merge 1:1 ubigeo using "$Saneamiento\05. Saneamiento.dta", nogen
merge 1:1 ubigeo using "$Electrificación\06. Electrificación rural.dta", keepusing(P_Sin_electricidad_rural P_Población_rural) nogen
merge 1:1 ubigeo using "$Telecomunicación\08. Telecomunicación rural.dta", nogen
merge 1:1 ubigeo using "$Desarrollo_Productivo\09. Apoyo al desarrollo productivo.dta", nogen
merge 1:1 ubigeo using "$Recursos_Presupuestales\10. Recursos Presupuestales.dta", nogen
merge 1:1 ubigeo using "$Pobreza\11. Pobreza monetaria 2018.dta", nogen

* Rename vars.
*'''''''''''''
rename Establecimientos_salud_SP       v01_Establecimientos_salud_SP 
rename P_Con_discapacidad              v02_Con_discapacidad
rename P_Sin_seguro                    v03_Sin_seguro 
rename Desnutricion_cromica            v04_Desnutricion_cromica
rename Anemia_total                    v05_Anemia_total
rename P_Analfabeta               	   v06_No_leer_escribir 
rename Asiste_IE_otro_distrito         v07_Asiste_IE_otro_distrito 
rename Nivel_secundaria_más_17         v08_Nivel_secundaria_más_17
rename Schooling                       v09_Años_escolaridad
rename No_estudian_6_17                v10_No_estudian_6_17
rename Sin_electricidad_LE             v11_Sin_electricidad_LE
rename Sin_aula_acondicionada_LE       v12_Sin_aula_acondicionada_LE
rename Sin_PC_Tablet_Laptop            v13_Sin_PC_Tablet_Laptop
rename Años_existencia_infra_LE        v14_Años_existencia_infra_LE
rename No_Registros_Públicos_LE        v15_No_Registros_Públicos_LE
rename No_paredes_aula_LE              v16_No_paredes_aula_LE
rename No_piso_aula_LE                 v17_No_piso_aula_LE
rename No_techo_aula_LE                v18_No_techo_aula_LE
rename Sin_agua_LE                     v19_Sin_agua_LE  
rename Sin_desagüe_LE                  v20_Sin_desagüe_LE
*rename xxx                            v21_xxx
*rename xxx                            v22_xxx
rename Cerco_perimétrico_total         v23_Cerco_perimétrico_total
rename Cerco_perimétrico_parcial       v23_Cerco_perimétrico_parcial
rename Cerco_perimétrico_no_tiene      v23_Cerco_perimétrico_no_tiene
rename Cantidad_LE                     v24_Cantidad_LE
rename cond_inadecuadas_inicial 	   v25_cond_inadecuadas_inicial
rename cond_inadecuadas_primaria 	   v26_cond_inadecuadas_primaria
rename cond_inadecuadas_secundaria     v27_cond_inadecuadas_secundaria
rename Red_vial_regional_inadecuadas   v28_Red_vial_regional_inade
rename Red_vial_regional_implementar   v29_Red_vial_regional_imple
rename Red_vial_nacional_inadecuadas   v30_Red_vial_nacional_inade
rename Red_vial_nacional_implementar   v31_Red_vial_nacional_imple
rename Red_vial_vecinal_inadecuadas    v32_Red_vial_vecinal_inade
rename Red_vial_vecinal_implementar    v33_Red_vial_vecinal_imple
rename P_Sin_agua                      v34_Sin_agua
rename P_Sin_desagüe                   v35_Sin_desagüe
rename P_Sin_electricidad_rural        v36_Sin_electricidad_rural
rename P_Población_rural               v37_P_Población_rural
rename P_Sin_teléfono_celular_rural    v38_Sin_teléfono_celular_rural
rename P_Sin_teléfono_fijo_rural       v39_Sin_teléfono_fijo_rural
rename P_Sin_conexión_internet_rural   v40_Sin_conexión_internet_rural
rename Cobertura_inter_movil_rural     v41_Cobertura_inter_movil_rural
rename PEA_Agri_gana_silvi_pesca       v42_PEA_Agri_gana_silvi_pesca
rename Superficie_agrícola_ha          v43_Superficie_agrícola_ha
rename Superficie_territorial_ha       v43_Superficie_territorial_ha 
rename VBP_corriente_2023 		       v44_VBP_corriente_2023
rename Número_productores 		       v45_Número_productores
rename PIM_promedio_total_mean         v46_PIM_promedio_total_mean
rename PIM_promedio_total_all          v46_PIM_promedio_total_all
rename PIM_promedio_FIDT_mean          v47_PIM_promedio_FIDT_mean
rename PIM_promedio_FIDT_all           v47_PIM_promedio_FIDT_all
rename PIM_promedio_donaciones_mean    v48_PIM_promedio_donaciones_mean
rename PIM_promedio_donaciones_all     v48_PIM_promedio_donaciones_all
*rename Ejecución_total                 v49_Ejecución_total
*rename Ejecución_FIDT                  v50_Ejecución_FIDT
*rename Ejecución_donaciones  		   v51_Ejecución_donaciones
rename Pobreza_monetaria               v52_Pobreza_monetaria

global vars = "v01_Establecimientos_salud_SP v02_Con_discapacidad v03_Sin_seguro v04_Desnutricion_cromica v05_Anemia_total v06_No_leer_escribir v07_Asiste_IE_otro_distrito v08_Nivel_secundaria_más_17 v09_Años_escolaridad v10_No_estudian_6_17 v11_Sin_electricidad_LE v12_Sin_aula_acondicionada_LE v13_Sin_PC_Tablet_Laptop v14_Años_existencia_infra_LE v15_No_Registros_Públicos_LE v16_No_paredes_aula_LE v17_No_piso_aula_LE v18_No_techo_aula_LE v19_Sin_agua_LE v20_Sin_desagüe_LE v23_Cerco_perimétrico_total v23_Cerco_perimétrico_parcial v23_Cerco_perimétrico_no_tiene v24_Cantidad_LE v25_cond_inadecuadas_inicial v26_cond_inadecuadas_primaria v27_cond_inadecuadas_secundaria v28_Red_vial_regional_inade v29_Red_vial_regional_imple v30_Red_vial_nacional_inade v31_Red_vial_nacional_imple v32_Red_vial_vecinal_inade v33_Red_vial_vecinal_imple v34_Sin_agua v35_Sin_desagüe v36_Sin_electricidad_rural v37_P_Población_rural v38_Sin_teléfono_celular_rural v39_Sin_teléfono_fijo_rural v40_Sin_conexión_internet_rural v41_Cobertura_inter_movil_rural v42_PEA_Agri_gana_silvi_pesca v43_Superficie_agrícola_ha v43_Superficie_territorial_ha v44_VBP_corriente_2023 v45_Número_productores v52_Pobreza_monetaria"

* Imputation 
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

foreach x in "v46_PIM_promedio_total_mean" "v46_PIM_promedio_total_all" "v47_PIM_promedio_FIDT_mean" "v47_PIM_promedio_FIDT_all" "v48_PIM_promedio_donaciones_mean" "v48_PIM_promedio_donaciones_all" {
	replace `x' = 0 if  `x' == .
}

* Apurímac - Chincheros
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

foreach x in $vars {
	summarize `x' if ubigeo == "030604"
	local v01 = r(mean)
	replace `x' = `v01' if ubigeo == "030612" & `x' == .
}


* Ayacucho - Huanta
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
foreach x in $vars {
	quietly: summarize `x' if ubigeo == "050406"
	local v02 = r(mean)
	replace `x' = `v02' if ubigeo == "050413" & `x' == .
}

* Ayacucho - La Mar
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
foreach x in $vars {
	quietly: summarize `x' if ubigeo == "050502"
	local v03 = r(mean)
	replace `x' = `v03' if ubigeo == "050512" & `x' == .
}
br if ubigeo == "050502" | ubigeo == "050512"

foreach x in $vars {
	quietly: summarize `x' if ubigeo == "050503"
	local v04 = r(mean)
	replace `x' = `v04' if ubigeo == "050513" & `x' == .
}
br if ubigeo == "050503" | ubigeo == "050513"

foreach x in $vars {
	quietly: summarize `x' if ubigeo == "050501"
	local v05 = r(mean)
	local v06 = r(mean)
	replace `x' = `v05' if ubigeo == "050514" & `x' == .
	replace `x' = `v06' if ubigeo == "050515" & `x' == .
}
br if ubigeo == "050501" | ubigeo == "050514" | ubigeo == "050515"

* Cusco - La Convención
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
foreach x in $vars {
	quietly: summarize `x' if ubigeo == "080902" | ubigeo == "080909"
	local v07 = r(mean)
	replace `x' = `v07' if ubigeo == "080915" & `x' == .
}

br if ubigeo == "080902" | ubigeo == "080909" | ubigeo == "080915"

foreach x in $vars {
	quietly: summarize `x'  if ubigeo == "080907"
	local v08 = r(mean)
	local v09 = r(mean)
	replace `x' = `v08' if ubigeo == "080916" & `x' == .
	replace `x' = `v09' if ubigeo == "080917" & `x' == .
}

br if ubigeo == "080907" | ubigeo == "080916" | ubigeo == "080917"

foreach x in $vars {
	quietly: summarize `x' if ubigeo == "080910"
	local v10 = r(mean)
	replace `x' = `v10' if ubigeo == "080918" & `x' == .
}

br if ubigeo == "080910" | ubigeo == "080918"

* Huancavelica - Tayacaja
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
foreach x in $vars {
	quietly: summarize `x' if ubigeo == "090707" | ubigeo == "090717"
	local v11 = r(mean)
	replace `x' = `v11' if ubigeo == "090724" & `x' == .
}

br if ubigeo == "090707" | ubigeo == "090717" | ubigeo == "090724"

foreach x in $vars {
	quietly: summarize `x' if ubigeo == "090718"
	local v12 = r(mean)
	replace `x' = `v12' if ubigeo == "090725" & `x' == .
}
br if ubigeo == "090718" | ubigeo == "090725"

* La Libertad - Trujillo
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
foreach x in $vars {
	quietly: summarize `x' if ubigeo == "130106"
	local v13 = r(mean)
	replace `x' = `v13' if ubigeo == "130112" & `x' == .
}
br if ubigeo == "130106" | ubigeo == "130112"

* Moquegua - Mariscal Nieto
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
foreach x in $vars {
	quietly: summarize `x' if ubigeo == "180101"
	local v14 = r(mean)
	replace `x' = `v14' if ubigeo == "180107" & `x' == .
}
br if ubigeo == "180101" | ubigeo == "180107"

* San Martín - Tocache
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
foreach x in $vars {
	quietly: summarize `x' if ubigeo == "221005"
	local v15 = r(mean)
	replace `x' = `v15' if ubigeo == "221006" & `x' == .
}
br if ubigeo == "221005" | ubigeo == "221006"

* Ucayali - Padre Abad
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
foreach x in $vars {
	quietly: summarize `x' if ubigeo == "250301" | ubigeo == "250303" | ubigeo == "250304" | ubigeo == "250305"
	local v16 = r(mean)
	local v17 = r(mean)
	replace `x' = `v16' if ubigeo == "250306" & `x' == .
	replace `x' = `v17' if ubigeo == "250307" & `x' == .
}

br if ubigeo == "250301" | ubigeo == "250303" | ubigeo == "250304" | ubigeo == "250305" | ubigeo == "250306" | ubigeo == "250307"


* Imputación a valores rurales
global vars_rural = "v36_Sin_electricidad_rural v37_P_Población_rural v38_Sin_teléfono_celular_rural v39_Sin_teléfono_fijo_rural v40_Sin_conexión_internet_rural"

foreach x in $vars_rural {
	replace `x' = 0 if `x' == .
}

replace v41_Cobertura_inter_movil_rural = 4 if v41_Cobertura_inter_movil_rural == .

********************************************************************************
********************************************************************************
********************************************************************************

* Imputation 
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
* Porcentaje red vial vecinal en condiciones inadecuadas
* Porcentaje red vial vecinal por implementar
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global vars_vial = "v32_Red_vial_vecinal_inade v33_Red_vial_vecinal_imple"
foreach x in $vars_vial {
	summarize `x' if substr(ubigeo,1,4)=="1501" // 15 Lima - 01 Lima
	local v01 = r(mean)
	replace `x' = `v01' if substr(ubigeo,1,2)=="07" & `x' == .
}

	
* Imputation at the provincial level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
gen id_reg_prov = substr(ubigeo,1,4)

foreach x in $vars {
	bys id_reg_prov: egen `x'i = mean(`x')
	replace `x' = `x'i if `x'==.
	drop `x'i
}
drop id_reg_prov

* Imputation at the regional level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
mdesc

gen id_reg = substr(ubigeo,1,2)

foreach x in $vars {
	bys id_reg: egen `x'i = mean(`x')
	replace `x' = `x'i if `x'==.
	drop `x'i
}
drop id_reg

mdesc

********************************************************************************
********************************************************************************
********************************************************************************

gen id_reg_prov = substr(ubigeo,1,4)

global vars_num = "v01_Establecimientos_salud_SP v09_Años_escolaridad v24_Cantidad_LE v41_Cobertura_inter_movil_rural v43_Superficie_agrícola_ha v43_Superficie_territorial_ha v45_Número_productores"

foreach x in $vars_num {
	bys id_reg_prov: egen `x'x = max(`x')
	gen `x'm = `x'x - `x' 
	drop `x'x
	order `x'm, after(`x')
}

drop id_reg_prov

sort ubigeo

********************************************************************************
********************************************************************************
********************************************************************************

save "$Input\Data_Warehouse.dta", replace
save "$Path\Data_Warehouse.dta", replace
