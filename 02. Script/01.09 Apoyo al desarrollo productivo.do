clear all
set more off

********************************************************************************
* Tema: Apoyo al desarrollo productivo
* Elaboracion: Carlos Torres
********************************************************************************

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path       = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024"
global Ubigeo     = "$Path\01. Input\00. Dataset\00. Ubigeo"
*global Censo_2017 = "$Path\01. Input\00. Dataset\01. Censo 2017"
global Censo_2017 = "E:\01. DataBase\FIDT\01. Censo 2017" // Debido al peso, los archivos del Censo no se subieron a GitHub
global MIDAGRI    = "$Path\01. Input\00. Dataset\08. MIDAGRI"
global Output     = "$Path\01. Input\09. Apoyo al desarrollo productivo"

********************************************************************************
********************************************************************************
* Porcentaje de PEA ocupada agrícola
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Censo_2017\cpv2017_pob.dta", clear

gen ubigeo = ccdd + ccpp + ccdi

* Filtering data
*'''''''''''''''

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

merge m:1 Cod_act_eco using "$Censo_2017\ACTIVIDADES ECONÓMICAS.dta"
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

import excel "$MIDAGRI\2024 11.05 BD informaci n SEIA.xlsx", sheet("01.Superficie Agricola") firstrow clear cellrange(B4:G1878)

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

import excel "$MIDAGRI\2024 11.05 BD informaci n SEIA.xlsx", sheet("02.Valor Bruto de la Producción") firstrow clear cellrange(B4:J30883)

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

import excel "$MIDAGRI\2024 11.05 BD informaci n SEIA.xlsx", sheet("03.Número de productores") firstrow clear cellrange(B4:F1858)

rename UBIGEO      ubigeo
rename PRODUCTORES Número_productores

keep  ubigeo Número_productores
order ubigeo Número_productores

save "$Output\Número de productores.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************

* Merging datasets
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Ubigeo\UBIGEO 2022.dta", clear
merge 1:1 ubigeo using "$Output\PEA ocupada agrícola.dta", nogen
merge 1:1 ubigeo using "$Output\Superficie Agricola.dta", nogen
merge 1:1 ubigeo using "$Output\Valor Bruto de la Producción.dta", nogen
merge 1:1 ubigeo using "$Output\Número de productores.dta", nogen

mdesc

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\09. Apoyo al desarrollo productivo_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\09. Apoyo al desarrollo productivo.dta", replace
