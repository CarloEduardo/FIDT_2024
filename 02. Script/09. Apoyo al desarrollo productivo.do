* Tema: Apoyo al desarrollo productivo
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path_1 = "E:\01. DataBase\1. INEI\5 CVP 2017"
global Path_2 = "E:\01. DataBase\1. INEI\4 SISCONCODE"
global Path_3 = "E:\01. DataBase\5. MIDAGRI"
global Ubigeo = "E:\01. DataBase\1. INEI\4 SISCONCODE\01. UBIGEO 2022"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\09. Apoyo al desarrollo productivo"

********************************************************************************
********************************************************************************
* Porcentaje de PEA ocupada agrícola
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Path_1\cpv2017_pob.dta", clear

gen ubigeo = ccdd + ccpp + ccdi

* Filtering data
*'''''''''''''''

fre thogar // thogar -- p: total de hogares 
br   if thogar=="99"
drop if thogar=="99"

keep if c5_p4_1>=14 // p: edad en años

drop if c5_p20_cod=="" // c5_p20_cod -- p5a+: la semana pasada a que actividad se dedicó el negocio, organismo o empres

fre c5_p16
/*
c5_p16 -- p5a+: la semana pasada - trabajó por algún pago en dinero o especie
----------------------------------------------------------------------------------
                                     |      Freq.    Percent      Valid       Cum.
-------------------------------------+--------------------------------------------
Valid   1 si, trabajó por algún pago |   1.04e+07      88.75      88.75      88.75
        2 no, trabajó por algún pago |    1323733      11.25      11.25     100.00
        Total                        |   1.18e+07     100.00     100.00           
----------------------------------------------------------------------------------
*/

*c5_p19_cod => p5a+: la semana pasada ¿cuál es la ocupación principal?
*c5_p20_cod => p5a+: la semana pasada a que actividad se dedicó el negocio, organismo o empres

codebook c5_p19_cod // 464 obs 
codebook c5_p20_cod // 415 obs

gen Cod_act_eco = c5_p20_cod

merge m:1 Cod_act_eco using "$Path_2\ACTIVIDADES ECONÓMICAS.dta"
drop if _merge==2

gen PEA_Agri_gana_silvi_pesca=cond(SECCION=="A Agricultura, ganadería, silvicultura y pesca",1,0)

collapse (mean) PEA_Agri_gana_silvi_pesca [iw=factor_pond], by(ubigeo)

save "$Output\PEA ocupada agrícola.dta", replace

********************************************************************************
********************************************************************************
* Superficie agropecuaria
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path_3\2024 11.05 BD informaci n SEIA.xlsx", sheet("01.Superficie Agricola") firstrow clear cellrange(B4:G1878)

rename UBIGEO             ubigeo
rename Áreaagrícola2018ha Superficie_agrícola_ha
rename Áreaterritorialha  Superficie_territorial_ha

keep  ubigeo Superficie_agrícola_ha Superficie_territorial_ha
order ubigeo Superficie_agrícola_ha Superficie_territorial_ha

save "$Output\Superficie Agricola.dta", replace

********************************************************************************
********************************************************************************
* Valor bruto de la producción
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path_3\2024 11.05 BD informaci n SEIA.xlsx", sheet("02.Valor Bruto de la Producción") firstrow clear cellrange(B4:J30883)

rename UBIGEO             ubigeo
rename VBP_CORRIENTE2023milesdeS VBP_corriente_2023

collapse (sum) VBP_corriente_2023, by(ubigeo)

save "$Output\Valor Bruto de la Producción.dta", replace

********************************************************************************
********************************************************************************
* Número de productores
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path_2\2024 11.05 BD informaci n SEIA.xlsx", sheet("03.Número de productores") firstrow clear cellrange(B4:F1858)

rename UBIGEO      ubigeo
rename PRODUCTORES Número_productores

keep  ubigeo Número_productores
order ubigeo Número_productores

save "$Output\Número de productores.dta", replace

********************************************************************************
********************************************************************************

use "$Ubigeo\UBIGEO 2022.dta", clear
merge 1:1 ubigeo using "$Output\PEA ocupada agrícola.dta", nogen
merge 1:1 ubigeo using "$Output\Superficie Agricola.dta", nogen
merge 1:1 ubigeo using "$Output\Valor Bruto de la Producción.dta", nogen
merge 1:1 ubigeo using "$Output\Número de productores.dta", nogen

* Imputation at the provincial level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
mdesc

gen id_reg_prov = substr(ubigeo,1,4)

bys id_reg_prov: egen PEA_Agri_gana_silvi_pesca_ip = mean(PEA_Agri_gana_silvi_pesca)
bys id_reg_prov: egen Superficie_agrícola_ha_ip    = mean(Superficie_agrícola_ha)
bys id_reg_prov: egen Superficie_territorial_ha_ip = mean(Superficie_territorial_ha)
bys id_reg_prov: egen VBP_corriente_2023_ip   	   = mean(VBP_corriente_2023)
bys id_reg_prov: egen Número_productores_ip        = mean(Número_productores)

replace PEA_Agri_gana_silvi_pesca =PEA_Agri_gana_silvi_pesca_ip if PEA_Agri_gana_silvi_pesca==.
replace Superficie_agrícola_ha    =Superficie_agrícola_ha_ip    if Superficie_agrícola_ha==.
replace Superficie_territorial_ha =Superficie_territorial_ha_ip if Superficie_territorial_ha==.
replace VBP_corriente_2023        =VBP_corriente_2023_ip        if VBP_corriente_2023==.
replace Número_productores        =Número_productores_ip        if Número_productores==.

drop id_reg_prov PEA_Agri_gana_silvi_pesca_ip Superficie_agrícola_ha_ip Superficie_territorial_ha_ip VBP_corriente_2023_ip Número_productores_ip

mdesc

* Imputation at the regional level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
mdesc

gen id_reg = substr(ubigeo,1,2)

bys id_reg: egen PEA_Agri_gana_silvi_pesca_ir = mean(PEA_Agri_gana_silvi_pesca)
bys id_reg: egen Superficie_agrícola_ha_ir    = mean(Superficie_agrícola_ha)
bys id_reg: egen Superficie_territorial_ha_ir = mean(Superficie_territorial_ha)
bys id_reg: egen VBP_corriente_2023_ir   	  = mean(VBP_corriente_2023)
bys id_reg: egen Número_productores_ir        = mean(Número_productores)

replace PEA_Agri_gana_silvi_pesca =PEA_Agri_gana_silvi_pesca_ir if PEA_Agri_gana_silvi_pesca==.
replace Superficie_agrícola_ha    =Superficie_agrícola_ha_ir    if Superficie_agrícola_ha==.
replace Superficie_territorial_ha =Superficie_territorial_ha_ir if Superficie_territorial_ha==.
replace VBP_corriente_2023        =VBP_corriente_2023_ir        if VBP_corriente_2023==.
replace Número_productores        =Número_productores_ir        if Número_productores==.

drop id_reg PEA_Agri_gana_silvi_pesca_ir Superficie_agrícola_ha_ir Superficie_territorial_ha_ir VBP_corriente_2023_ir Número_productores_ir

mdesc

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\09. Apoyo al desarrollo productivo_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\09. Apoyo al desarrollo productivo.dta", replace






