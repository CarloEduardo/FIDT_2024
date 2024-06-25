clear all
set more off

********************************************************************************
* Tema: Indicadores FIDT
* Elaboracion: 
********************************************************************************

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path   = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024"
global Output = "$Path\03. Output"

********************************************************************************
*                             A NIVEL DE DISTRITOS                             *
********************************************************************************

* RECURSOS DISTRITOS
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Output\Data_Warehouse_distrito.dta", clear

gen provincia = substr(ubigeo,5,2)
keep if provincia != "01"

replace v46_PIM_promedio_total_all=0 if v46_PIM_promedio_total_all==.
replace v47_PIM_promedio_FIDT_all=0 if v47_PIM_promedio_FIDT_all==.
replace v48_PIM_promedio_donaciones_all=0 if v48_PIM_promedio_donaciones_all==.

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

xtile decil_rec = Ind_rec, nquantiles(10)

gen decil_recursos=decil_rec

label define decil_recursos 1 "Menos recursos" 2 "Menos recursos" 3 "Menos recursos" 4 "Menos recursos" 5 "Menos recursos" 6 "Menos recursos" 7 "Menos recursos" 8 "Recursos medios" 9 "Recursos medios" 10 "Mas recursos"
label value decil_recursos decil_recursos
tab   decil_recursos decil_rec

save "$Output\IND_RECURSOS_DIS.dta", replace

* NECESIDADES DISTRITOS
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Output\Data_Warehouse_distrito.dta", clear

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

gen v08_Nivel_secundaria_más_17_2 = 1- v08_Nivel_secundaria_más_17
 
factortest v02_Con_discapacidad v03_Sin_seguro v04_Desnutricion_cromica v05_Anemia_total v06_No_leer_escribir v07_Asiste_IE_otro_distrito v08_Nivel_secundaria_más_17_2 v10_No_estudian_6_17 v11_Sin_electricidad_LE v12_Sin_aula_acondicionada_LE v13_Sin_PC_Tablet_Laptop v14_Años_existencia_infra_LE v15_No_Registros_Públicos_LE v16_No_paredes_aula_LE v17_No_piso_aula_LE v18_No_techo_aula_LE v19_Sin_agua_LE v20_Sin_desagüe_LE  v25_cond_inadecuadas_inicial v26_cond_inadecuadas_primaria v27_cond_inadecuadas_secundaria  v34_Sin_agua v35_Sin_desagüe v36_Sin_electricidad_rural v37_P_Población_rural v38_Sin_teléfono_celular_rural v39_Sin_teléfono_fijo_rural v40_Sin_conexión_internet_rural  v01_Establecimientos_salud_SP_2 v09_Años_escolaridad_2 v24_Cantidad_LE_2 v41_Cobertura_inter_rural_2 v43_Superficie_agrícola_ha_2 v43_Superficie_territorial_ha_2  v45_Número_productores_2  

factor v02_Con_discapacidad v03_Sin_seguro v04_Desnutricion_cromica v05_Anemia_total v06_No_leer_escribir v07_Asiste_IE_otro_distrito v08_Nivel_secundaria_más_17_2 v10_No_estudian_6_17 v11_Sin_electricidad_LE v12_Sin_aula_acondicionada_LE v13_Sin_PC_Tablet_Laptop v14_Años_existencia_infra_LE v15_No_Registros_Públicos_LE v16_No_paredes_aula_LE v17_No_piso_aula_LE v18_No_techo_aula_LE v19_Sin_agua_LE v20_Sin_desagüe_LE  v25_cond_inadecuadas_inicial v26_cond_inadecuadas_primaria v27_cond_inadecuadas_secundaria  v34_Sin_agua v35_Sin_desagüe v36_Sin_electricidad_rural v37_P_Población_rural v38_Sin_teléfono_celular_rural v39_Sin_teléfono_fijo_rural v40_Sin_conexión_internet_rural  v01_Establecimientos_salud_SP_2 v09_Años_escolaridad_2 v24_Cantidad_LE_2 v41_Cobertura_inter_rural_2 v43_Superficie_agrícola_ha_2 v43_Superficie_territorial_ha_2  v45_Número_productores_2 v28_Red_vial_regional_inade v29_Red_vial_regional_imple v30_Red_vial_nacional_inade v31_Red_vial_nacional_imple v32_Red_vial_vecinal_inade v33_Red_vial_vecinal_imple , pcf mineigen (0.999)

screeplot, yline (1)
rotate, kaiser 

predict factor*, regression

egen mini1  = min(factor1)
egen max1   = max(factor1)
gen nfactor1= (factor1-mini1)/(max1-mini1)

egen mini2  = min(factor2)
egen max2   = max(factor2)
gen nfactor2= (factor2-mini2)/(max2-mini2)

egen mini3  = min(factor3)
egen max3   = max(factor3)
gen nfactor3= (factor3-mini3)/(max3-mini3)

egen mini4  = min(factor4)
egen max4   = max(factor4)
gen nfactor4= (factor4-mini4)/(max4-mini4)

egen mini5  = min(factor5)
egen max5   = max(factor5)
gen nfactor5= (factor5-mini5)/(max5-mini5)

egen mini6  = min(factor6)
egen max6   = max(factor6)
gen nfactor6= (factor6-mini6)/(max6-mini6)

egen mini7  = min(factor7)
egen max7   = max(factor7)
gen nfactor7= (factor7-mini7)/(max7-mini7)

egen mini8  = min(factor8)
egen max8   = max(factor8)
gen nfactor8= (factor8-mini8)/(max8-mini8)

egen mini9  = min(factor9)
egen max9   = max(factor9)
gen nfactor9= (factor9-mini9)/(max9-mini9)

egen mini10  = min(factor10)
egen max10   = max(factor10)
gen nfactor10= (factor10-mini10)/(max10-mini10)

gen In_Ne =(nfactor1*0.1301/0.6455+nfactor2*0.1177/0.6455+nfactor3*0.0870/0.6455+nfactor4*0.0726/0.6455+nfactor5*0.0605/0.6455+nfactor6*0.0475/0.6455+nfactor7*0.0377/0.6455+nfactor8*0.0340/0.6455+nfactor9*0.0303/0.6455+nfactor10*0.0282/0.6455)/10

xtile decil_nec = In_Ne, nquantiles(10)
gen decil_necesidades= decil_nec

label define decil_necesidades 1 "Necesidad media" 2 "Alta necesidad" 3 "Alta necesidad" 4 "Muy alta necesidad" 5 "Muy alta necesidad" 6 "Muy alta necesidad" 7 "Muy alta necesidad" 8 "Muy alta necesidad" 9 "Muy alta necesidad" 10 "Muy alta necesidad"

label value decil_necesidades decil_necesidades
tab   decil_necesidades decil_nec

merge 1:1 ubigeo using "$Output\IND_RECURSOS_DIS.dta"

save "$Output\RES_DISTRITOS.dta", replace

use "$Output\RES_DISTRITOS.dta", clear

twoway (scatter In_Ne v52_Pobreza_monetaria)
pwcorr In_Ne v52_Pobreza_monetaria

tab decil_necesidades decil_recursos

sort v52_Pobreza_monetaria
gen ID=_n

hist In_Ne 

replace decil_recursos= 10 if ID < 21
replace decil_recursos=  1 if ID > 1676

export excel ubigeo REGION PROVINCIA DISTRITO  v01_Establecimientos_salud_SP v02_Con_discapacidad v03_Sin_seguro v04_Desnutricion_cromica v05_Anemia_total v06_No_leer_escribir v07_Asiste_IE_otro_distrito v08_Nivel_secundaria_más_17 v09_Años_escolaridad v10_No_estudian_6_17 v11_Sin_electricidad_LE v12_Sin_aula_acondicionada_LE v13_Sin_PC_Tablet_Laptop v14_Años_existencia_infra_LE v15_No_Registros_Públicos_LE v16_No_paredes_aula_LE v17_No_piso_aula_LE v18_No_techo_aula_LE v19_Sin_agua_LE v20_Sin_desagüe_LE v24_Cantidad_LE v25_cond_inadecuadas_inicial v26_cond_inadecuadas_primaria v27_cond_inadecuadas_secundaria v28_Red_vial_regional_inade v29_Red_vial_regional_imple v30_Red_vial_nacional_inade v31_Red_vial_nacional_imple v32_Red_vial_vecinal_inade v33_Red_vial_vecinal_imple v34_Sin_agua v35_Sin_desagüe v36_Sin_electricidad_rural v37_P_Población_rural v38_Sin_teléfono_celular_rural v39_Sin_teléfono_fijo_rural v40_Sin_conexión_internet_rural v41_Cobertura_inter_movil_rural v43_Superficie_agrícola_ha v43_Superficie_territorial_ha v45_Número_productores v46_PIM_promedio_total_all v47_PIM_promedio_FIDT_all  v48_PIM_promedio_donaciones_all v52_Pobreza_monetaria In_Ne  Ind_rec decil_necesidades decil_recursos decil_nec decil_rec using "$Output\RESUL_DISTRITOS.xls", sheetreplace firstrow(variables) 

********************************************************************************
*                             A NIVEL DE PROVINCIA                             *
********************************************************************************

* RECURSOS PROVINCIA
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Output\Data_Warehouse_provincia.dta", clear

replace v46_PIM_promedio_total_all=0 if v46_PIM_promedio_total_all==.
replace v47_PIM_promedio_FIDT_all=0 if v47_PIM_promedio_FIDT_all==.
replace v48_PIM_promedio_donaciones_all=0 if v48_PIM_promedio_donaciones_all==.

factortest v46_PIM_promedio_total_all v47_PIM_promedio_FIDT_all v48_PIM_promedio_donaciones_all 

factor v46_PIM_promedio_total_all v47_PIM_promedio_FIDT_all v48_PIM_promedio_donaciones_all, pcf mineigen (0.99)

screeplot, yline (1)
rotate, kaiser 

predict factor*, regression

egen mini  = min(factor1)
egen max  = max(factor1)
gen nfactor1= (factor1-mini)/(max-mini)

rename nfactor1 Ind_rec
hist Ind_rec
xtile decil_rec = Ind_rec, nquantiles(10)

gen decil_recursos=decil_rec

label define decil_recursos 1 "Menos recursos" 2 "Menos recursos" 3 "Menos recursos" 4 "Menos recursos" 5 "Menos recursos" 6 "Menos recursos" 7 "Recursos medios" 8 "Mas recursos" 9 "Mas recursos" 10 "Mas recursos"
label value decil_recursos decil_recursos
tab   decil_recursos decil_rec

save "$Output\IND_RECURSOS_PRO.dta", replace

* NECESIDADES PROVINCIA
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Output\Data_Warehouse_provincia.dta", clear

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

gen v08_Nivel_secundaria_más_17_2 = 1- v08_Nivel_secundaria_más_17

factortest v02_Con_discapacidad v03_Sin_seguro v04_Desnutricion_cromica v05_Anemia_total v06_No_leer_escribir v07_Asiste_IE_otro_distrito v08_Nivel_secundaria_más_17_2 v10_No_estudian_6_17 v11_Sin_electricidad_LE v12_Sin_aula_acondicionada_LE v13_Sin_PC_Tablet_Laptop v14_Años_existencia_infra_LE v15_No_Registros_Públicos_LE v16_No_paredes_aula_LE v17_No_piso_aula_LE v18_No_techo_aula_LE v19_Sin_agua_LE v20_Sin_desagüe_LE  v25_cond_inadecuadas_inicial v26_cond_inadecuadas_primaria v27_cond_inadecuadas_secundaria  v34_Sin_agua v35_Sin_desagüe v36_Sin_electricidad_rural v37_P_Población_rural v38_Sin_teléfono_celular_rural v39_Sin_teléfono_fijo_rural v40_Sin_conexión_internet_rural  v01_Establecimientos_salud_SP_2 v09_Años_escolaridad_2 v24_Cantidad_LE_2 v41_Cobertura_inter_rural_2 v43_Superficie_agrícola_ha_2 v43_Superficie_territorial_ha_2  v45_Número_productores_2  

factor v02_Con_discapacidad v03_Sin_seguro v04_Desnutricion_cromica v05_Anemia_total v06_No_leer_escribir v07_Asiste_IE_otro_distrito v08_Nivel_secundaria_más_17_2 v10_No_estudian_6_17 v11_Sin_electricidad_LE v12_Sin_aula_acondicionada_LE v13_Sin_PC_Tablet_Laptop v14_Años_existencia_infra_LE v15_No_Registros_Públicos_LE v16_No_paredes_aula_LE v17_No_piso_aula_LE v18_No_techo_aula_LE v19_Sin_agua_LE v20_Sin_desagüe_LE  v25_cond_inadecuadas_inicial v26_cond_inadecuadas_primaria v27_cond_inadecuadas_secundaria  v34_Sin_agua v35_Sin_desagüe v36_Sin_electricidad_rural v37_P_Población_rural v38_Sin_teléfono_celular_rural v39_Sin_teléfono_fijo_rural v40_Sin_conexión_internet_rural  v01_Establecimientos_salud_SP_2 v09_Años_escolaridad_2 v24_Cantidad_LE_2 v41_Cobertura_inter_rural_2 v43_Superficie_agrícola_ha_2 v43_Superficie_territorial_ha_2  v45_Número_productores_2 v28_Red_vial_regional_inade v29_Red_vial_regional_imple v30_Red_vial_nacional_inade v31_Red_vial_nacional_imple v32_Red_vial_vecinal_inade v33_Red_vial_vecinal_imple , pcf mineigen (0.999)

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

gen In_Ne =(nfactor1*0.1633/0.7561+nfactor2*0.1451/0.7561+nfactor3*0.1303/0.7561+nfactor4*0.0791/0.7561+nfactor5*0.0531/0.7561+nfactor6*0.0512/0.7561+nfactor7*0.0380/0.7561+nfactor8*0.0361/0.7561+nfactor9*0.0319/0.7561+nfactor10*0.0279/0.7561)/10

xtile decil_nec = In_Ne, nquantiles(10)
gen decil_necesidades= decil_nec

label define decil_necesidades 1 "Necesidad media" 2 "Necesidad media" 3 "Necesidad media" 4 "Alta necesidad" 5 "Muy alta necesidad" 6 "Muy alta necesidad" 7 "Muy alta necesidad" 8 "Muy alta necesidad" 9 "Muy alta necesidad" 10 "Muy alta necesidad"

label value decil_necesidades decil_necesidades
tab   decil_necesidades decil_nec

merge 1:1 ubigeo_pro using "$Output\IND_RECURSOS_PRO.dta"

save "$Output\RES_PROVINCIA.dta", replace

use "$Output\RES_PROVINCIA.dta", clear

twoway (scatter In_Ne v52_Pobreza_monetaria)
pwcorr In_Ne v52_Pobreza_monetaria

tab decil_necesidades decil_recursos

sort v52_Pobreza_monetaria

gen ID=_n

export excel ubigeo REGION PROVINCIA   v01_Establecimientos_salud_SP v02_Con_discapacidad v03_Sin_seguro v04_Desnutricion_cromica v05_Anemia_total v06_No_leer_escribir v07_Asiste_IE_otro_distrito v08_Nivel_secundaria_más_17 v09_Años_escolaridad v10_No_estudian_6_17 v11_Sin_electricidad_LE v12_Sin_aula_acondicionada_LE v13_Sin_PC_Tablet_Laptop v14_Años_existencia_infra_LE v15_No_Registros_Públicos_LE v16_No_paredes_aula_LE v17_No_piso_aula_LE v18_No_techo_aula_LE v19_Sin_agua_LE v20_Sin_desagüe_LE v24_Cantidad_LE v25_cond_inadecuadas_inicial v26_cond_inadecuadas_primaria v27_cond_inadecuadas_secundaria v28_Red_vial_regional_inade v29_Red_vial_regional_imple v30_Red_vial_nacional_inade v31_Red_vial_nacional_imple v32_Red_vial_vecinal_inade v33_Red_vial_vecinal_imple v34_Sin_agua v35_Sin_desagüe v36_Sin_electricidad_rural v37_P_Población_rural v38_Sin_teléfono_celular_rural v39_Sin_teléfono_fijo_rural v40_Sin_conexión_internet_rural v41_Cobertura_inter_movil_rural v43_Superficie_agrícola_ha v43_Superficie_territorial_ha v45_Número_productores v46_PIM_promedio_total_all  v47_PIM_promedio_FIDT_all  v48_PIM_promedio_donaciones_all v52_Pobreza_monetaria In_Ne  Ind_rec decil_necesidades decil_recursos decil_nec decil_rec using "$Output\RESUL_PROVINCIA.xls", sheetreplace firstrow(variables) 

********************************************************************************
*                               A NIVEL DE REGION                              *
********************************************************************************

* RECURSOS REGION
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Output\Data_Warehouse_región.dta", clear

replace v46_PIM_promedio_total_all=0 if v46_PIM_promedio_total_all==.
replace v47_PIM_promedio_FIDT_all=0 if v47_PIM_promedio_FIDT_all==.
replace v48_PIM_promedio_donaciones_all=0 if v48_PIM_promedio_donaciones_all==.

factortest v46_PIM_promedio_total_all v47_PIM_promedio_FIDT_all v48_PIM_promedio_donaciones_all

factor  v46_PIM_promedio_total_all v47_PIM_promedio_FIDT_all v48_PIM_promedio_donaciones_all, pcf mineigen (0.99999)

screeplot, yline (1)
rotate, kaiser 

predict factor*, regression

egen mini  = min(factor1)
egen max  = max(factor1)
gen nfactor1= (factor1-mini)/(max-mini)

rename nfactor1 Ind_rec

xtile decil_rec = Ind_rec, nquantiles(10)

gen decil_recursos=decil_rec

hist Ind_rec

label define decil_recursos 1 "Menos recursos" 2 "Menos recursos" 3 "Menos recursos" 4 "Menos recursos" 5 "Menos recursos" 6 "Menos recursos" 7 "Menos recursos" 8 "Recursos medios" 9 "Recursos medios" 10 "Mas recursos"
label value decil_recursos decil_recursos
tab   decil_recursos decil_rec

hist Ind_rec 

save "$Output\IND_RECURSOS_REG.dta", replace

* NECESIDADES REGION
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Output\Data_Warehouse_región.dta", clear

replace v46_PIM_promedio_total_all=0 if v46_PIM_promedio_total_all==.
replace v47_PIM_promedio_FIDT_all=0 if v47_PIM_promedio_FIDT_all==.
replace v48_PIM_promedio_donaciones_all=0 if v48_PIM_promedio_donaciones_all==.

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

factortest v45_Número_productores_2 v43_Superficie_territorial_ha_2 v43_Superficie_agrícola_ha_2 v40_Sin_conexión_internet_rural v39_Sin_teléfono_fijo_rural v38_Sin_teléfono_celular_rural v37_P_Población_rural v36_Sin_electricidad_rural v35_Sin_desagüe v34_Sin_agua v28_Red_vial_regional_inade v24_Cantidad_LE_2 v14_Años_existencia_infra_LE v06_No_leer_escribir v05_Anemia_total v04_Desnutricion_cromica 

factor v45_Número_productores_2 v43_Superficie_territorial_ha_2 v43_Superficie_agrícola_ha_2 v40_Sin_conexión_internet_rural v39_Sin_teléfono_fijo_rural v38_Sin_teléfono_celular_rural v37_P_Población_rural v36_Sin_electricidad_rural v35_Sin_desagüe v34_Sin_agua v28_Red_vial_regional_inade v24_Cantidad_LE_2 v14_Años_existencia_infra_LE v06_No_leer_escribir v05_Anemia_total v04_Desnutricion_cromica, pcf mineigen (0.999)

screeplot, yline (1)
rotate, kaiser 

predict factor*, regression

egen mini1  = min(factor1)
egen max1   = max(factor1)
gen nfactor1= (factor1-mini1)/(max1-mini1)

egen mini2  = min(factor2)
egen max2   = max(factor2)
gen nfactor2= (factor2-mini2)/(max2-mini2)

egen mini3  = min(factor3)
egen max3   = max(factor3)
gen nfactor3= (factor3-mini3)/(max3-mini3)

egen mini4  = min(factor4)
egen max4   = max(factor4)
gen nfactor4= (factor4-mini4)/(max4-mini4)

gen In_Ne =(nfactor1*0.2689/0.8576+nfactor2*0.2545/0.8576+nfactor3*0.2358/0.8576+nfactor4*0.0984/0.8576)/4

xtile decil_nec = In_Ne, nquantiles(10)
gen decil_necesidades= decil_nec

label define decil_necesidades 1 "Necesidad media" 2 "Alta necesidad" 3 "Alta necesidad" 4 "Muy alta necesidad" 5 "Muy alta necesidad" 6 "Muy alta necesidad" 7 "Muy alta necesidad" 8 "Muy alta necesidad" 9 "Muy alta necesidad" 10 "Muy alta necesidad"

label value decil_necesidades decil_necesidades
tab   decil_necesidades decil_nec

merge 1:1 REGION using "$Output\IND_RECURSOS_REG.dta"

save "$Output\RES_REGION.dta", replace

use "$Output\RES_REGION.dta", clear

twoway (scatter In_Ne v52_Pobreza_monetaria)
pwcorr In_Ne v52_Pobreza_monetaria

hist In_Ne

tab decil_necesidades decil_recursos

sort v52_Pobreza_monetaria

gen ID=_n

replace decil_recursos= 10 if ID <9
replace decil_recursos= 1 if ID > 18

export excel ubigeo REGION v02_Con_discapacidad v03_Sin_seguro v04_Desnutricion_cromica v05_Anemia_total v06_No_leer_escribir v07_Asiste_IE_otro_distrito v08_Nivel_secundaria_más_17 v10_No_estudian_6_17 v11_Sin_electricidad_LE v12_Sin_aula_acondicionada_LE v14_Años_existencia_infra_LE  v16_No_paredes_aula_LE v17_No_piso_aula_LE v18_No_techo_aula_LE v19_Sin_agua_LE v20_Sin_desagüe_LE  v25_cond_inadecuadas_inicial v26_cond_inadecuadas_primaria v27_cond_inadecuadas_secundaria  v24_Cantidad_LE_2  v09_Años_escolaridad_2 v01_Establecimientos_salud_SP_2 v52_Pobreza_monetaria v46_PIM_promedio_total_all v47_PIM_promedio_FIDT_all v48_PIM_promedio_donaciones_all In_Ne  Ind_rec decil_necesidades decil_recursos decil_nec decil_rec using "$Output\RESUL_REGION.xls", sheetreplace firstrow(variables) 

erase "$Output\IND_RECURSOS_DIS.dta"
erase "$Output\IND_RECURSOS_PRO.dta"
erase "$Output\IND_RECURSOS_REG.dta"
