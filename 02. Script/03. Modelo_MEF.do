* Tema: Indicadores FIDT
* Elaboracion: Carlos Torres: 
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path   = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024"
global Ubigeo = "E:\01. DataBase\FIDT\00. Ubigeo"
global Input  = "$Path\01. Input"
global Output = "$Path\03. Output"

* Data Warehouse
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

****RECURSOS*******

use "$Output\Data_Warehouse.dta", clear

gen provincia = substr(ubigeo,5,2)
keep if provincia != "01"

factortest v46_PIM_promedio_total_all v47_PIM_promedio_FIDT_all v48_PIM_promedio_donaciones_all

factor v46_PIM_promedio_total_all v47_PIM_promedio_FIDT_all v48_PIM_promedio_donaciones_all, pcf mineigen (0.99)

screeplot, yline (1)
rotate, kaiser 


predict factor*, regression


egen mini  = min(factor1)
egen max  = max(factor1)
gen nfactor1= (factor1-mini)/(max-mini)

hist nfactor1

rename nfactor1 Ind_rec

xtile quintil_rec = Ind_rec, nquantiles(5)

gen quintil_recursos=quintil_rec

label define quintil_rec 1 "Menos recursos" 2 "Menos recursos" 3 "Menos recursos" 4 "Recursos medios" 5 "Mas recursos"
label value quintil_rec quintil_rec
tab quintil_rec

save "$Output\IND_REC.dta", replace


****NECESIDADES_V1*******


use "$Output\Data_Warehouse.dta", clear

gen provincia = substr(ubigeo,5,2)
keep if provincia != "01"

egen  v01_Establecimientos_salud_SP_ma = max(v01_Establecimientos_salud_SP)
gen v01_Establecimientos_salud_SP_2 = v01_Establecimientos_salud_SP_ma - v01_Establecimientos_salud_SP

egen v09_Años_escolaridad_ma = max(v09_Años_escolaridad)
gen v09_Años_escolaridad_2 = v09_Años_escolaridad_ma - v09_Años_escolaridad

egen v24_Cantidad_LE_ma = max(v24_Cantidad_LE)
gen v24_Cantidad_LE_2 = v24_Cantidad_LE_ma - v24_Cantidad_LE

egen v41_Cobertura_inter_rural_ma = max(v41_Cobertura_inter_movil_rural)
gen v41_Cobertura_inter_rural_2 = v41_Cobertura_inter_rural_ma - v41_Cobertura_inter_movil_rural


egen v43_Superficie_agrícola_ha_ma = max(v43_Superficie_agrícola_ha)
gen v43_Superficie_agrícola_ha_2 = v43_Superficie_agrícola_ha_ma - v43_Superficie_agrícola_ha

egen v43_Superficie_territorial_ha_ma = max(v43_Superficie_territorial_ha)
gen v43_Superficie_territorial_ha_2 = v43_Superficie_territorial_ha_ma - v43_Superficie_territorial_ha


egen v45_Número_productores_ma = max(v45_Número_productores)
gen v45_Número_productores_2 = v45_Número_productores_ma - v45_Número_productores


 
factortest v02_Con_discapacidad v03_Sin_seguro v04_Desnutricion_cromica v05_Anemia_total v06_No_leer_escribir v07_Asiste_IE_otro_distrito v08_Nivel_secundaria_más_17 v10_No_estudian_6_17 v11_Sin_electricidad_LE v12_Sin_aula_acondicionada_LE v13_Sin_PC_Tablet_Laptop v14_Años_existencia_infra_LE v15_No_Registros_Públicos_LE v16_No_paredes_aula_LE v17_No_piso_aula_LE v18_No_techo_aula_LE v19_Sin_agua_LE v20_Sin_desagüe_LE  v25_cond_inadecuadas_inicial v26_cond_inadecuadas_primaria v27_cond_inadecuadas_secundaria  v34_Sin_agua v35_Sin_desagüe v36_Sin_electricidad_rural v37_P_Población_rural v38_Sin_teléfono_celular_rural v39_Sin_teléfono_fijo_rural v40_Sin_conexión_internet_rural  v01_Establecimientos_salud_SP_2 v09_Años_escolaridad_2 v24_Cantidad_LE_2 v41_Cobertura_inter_rural_2 v43_Superficie_agrícola_ha_2 v43_Superficie_territorial_ha_2  v45_Número_productores_2  



factor v02_Con_discapacidad v03_Sin_seguro v04_Desnutricion_cromica v05_Anemia_total v06_No_leer_escribir v07_Asiste_IE_otro_distrito v08_Nivel_secundaria_más_17 v10_No_estudian_6_17 v11_Sin_electricidad_LE v12_Sin_aula_acondicionada_LE v13_Sin_PC_Tablet_Laptop v14_Años_existencia_infra_LE v15_No_Registros_Públicos_LE v16_No_paredes_aula_LE v17_No_piso_aula_LE v18_No_techo_aula_LE v19_Sin_agua_LE v20_Sin_desagüe_LE  v25_cond_inadecuadas_inicial v26_cond_inadecuadas_primaria v27_cond_inadecuadas_secundaria  v34_Sin_agua v35_Sin_desagüe v36_Sin_electricidad_rural v37_P_Población_rural v38_Sin_teléfono_celular_rural v39_Sin_teléfono_fijo_rural v40_Sin_conexión_internet_rural  v01_Establecimientos_salud_SP_2 v09_Años_escolaridad_2 v24_Cantidad_LE_2 v41_Cobertura_inter_rural_2 v43_Superficie_agrícola_ha_2 v43_Superficie_territorial_ha_2  v45_Número_productores_2 v28_Red_vial_regional_inade v29_Red_vial_regional_imple v30_Red_vial_nacional_inade v31_Red_vial_nacional_imple v32_Red_vial_vecinal_inade v33_Red_vial_vecinal_imple , pcf mineigen (0.999)


screeplot, yline (1)
rotate, kaiser 


predict factor*, regression

egen mini1  = min(factor1)
egen max1  = max(factor1)
gen nfactor1= (factor1-mini1)/(max1-mini1)

egen mini2  = min(factor2)
egen max2  = max(factor2)
gen nfactor2= (factor2-mini2)/(max2-mini2)

egen mini3  = min(factor3)
egen max3  = max(factor3)
gen nfactor3= (factor3-mini3)/(max3-mini3)

egen mini4  = min(factor4)
egen max4  = max(factor4)
gen nfactor4= (factor4-mini4)/(max4-mini4)

egen mini5  = min(factor5)
egen max5  = max(factor5)
gen nfactor5= (factor5-mini5)/(max5-mini5)

egen mini6  = min(factor6)
egen max6  = max(factor6)
gen nfactor6= (factor6-mini6)/(max6-mini6)

egen mini7  = min(factor7)
egen max7  = max(factor7)
gen nfactor7= (factor7-mini7)/(max7-mini7)

egen mini8  = min(factor8)
egen max8  = max(factor8)
gen nfactor8= (factor8-mini8)/(max8-mini8)

egen mini9  = min(factor9)
egen max9  = max(factor9)
gen nfactor9= (factor9-mini9)/(max9-mini9)

egen mini10  = min(factor10)
egen max10  = max(factor10)
gen nfactor10= (factor10-mini10)/(max10-mini10)


gen In_Ne =(nfactor1*0.1251/0.6745+nfactor2*0.1184/0.6745+nfactor3*0.0865/0.6745+nfactor4*0.0816/0.6745+nfactor5*0.0686/0.6745+nfactor6*0.0481/0.6745+nfactor7*0.0457/0.6745+nfactor8*0.0357/0.6745+nfactor9*0.0345/0.6745+nfactor10*0.0303/0.6745)/10

xtile quintil_nec = In_Ne, nquantiles(5)
gen quintil_necesidades = quintil_nec

label define quintil_nec 1 "Necesidad media" 2 "Alta necesidad" 3 "Muy alta necesidad" 4 "Muy alta necesidad" 5 "Muy alta necesidad"
label value quintil_nec quintil_nec
tab quintil_nec

merge 1:1 ubigeo using "$Output\IND_REC.dta"

save "$Output\IND_NEC_1.dta", replace
twoway (scatter In_Ne v52_Pobreza_monetaria)
pwcorr In_Ne v52_Pobreza_monetaria
hist In_Ne 
hist Ind_rec 


export excel ubigeo REGION PROVINCIA DISTRITO quintil_necesidades v01_Establecimientos_salud_SP v02_Con_discapacidad v03_Sin_seguro v04_Desnutricion_cromica v05_Anemia_total v06_No_leer_escribir v07_Asiste_IE_otro_distrito v08_Nivel_secundaria_más_17 v09_Años_escolaridad v10_No_estudian_6_17 v11_Sin_electricidad_LE v12_Sin_aula_acondicionada_LE v13_Sin_PC_Tablet_Laptop v14_Años_existencia_infra_LE v15_No_Registros_Públicos_LE v16_No_paredes_aula_LE v17_No_piso_aula_LE v18_No_techo_aula_LE v19_Sin_agua_LE v20_Sin_desagüe_LE v24_Cantidad_LE v25_cond_inadecuadas_inicial v26_cond_inadecuadas_primaria v27_cond_inadecuadas_secundaria v28_Red_vial_regional_inade v29_Red_vial_regional_imple v30_Red_vial_nacional_inade v31_Red_vial_nacional_imple v32_Red_vial_vecinal_inade v33_Red_vial_vecinal_imple v34_Sin_agua v35_Sin_desagüe v36_Sin_electricidad_rural v37_P_Población_rural v38_Sin_teléfono_celular_rural v39_Sin_teléfono_fijo_rural v40_Sin_conexión_internet_rural v41_Cobertura_inter_movil_rural v43_Superficie_agrícola_ha v43_Superficie_territorial_ha v45_Número_productores v46_PIM_promedio_total_all v47_PIM_promedio_FIDT_all  v48_PIM_promedio_donaciones_all v52_Pobreza_monetaria provincia In_Ne quintil_nec Ind_rec quintil_rec quintil_recursos  using "$Output\tabla_final_v2.xls", sheetreplace firstrow(variables) 
