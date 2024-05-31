* Tema: Recursos Presupuestales
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path   = "E:\01. DataBase\FIDT"
global Ubigeo = "$Path\00. Ubigeo"
global MEF    = "$Path\09. MEF"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\10. Recursos Presupuestales"

********************************************************************************
********************************************************************************
* PIM promedio total
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v2.xlsx", sheet("PIM TOTAL") firstrow clear cellrange(A6:G1897)

rename UBIGEO_SIAF   ubigeo
rename E PIM_total_2021
rename F PIM_total_2022
rename G PIM_total_2023

egen PIM_promedio_total_mean = rowmean(PIM_total_2021 PIM_total_2022 PIM_total_2023)

egen SUMA = rowtotal(PIM_total_2021 PIM_total_2022 PIM_total_2023)

gen PIM_promedio_total_all = SUMA/3

drop SUMA

keep  ubigeo PIM_total_2021 PIM_total_2022 PIM_total_2023 PIM_promedio_total_mean PIM_promedio_total_all
order ubigeo PIM_total_2021 PIM_total_2022 PIM_total_2023 PIM_promedio_total_mean PIM_promedio_total_all

unique ubigeo

save "$Output\PIM promedio total.dta", replace

********************************************************************************
********************************************************************************
* PIM promedio de inversiones cuya función es subvencionada por el FIDT
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v2.xlsx", sheet("PIM FUNCION FIDT") firstrow clear cellrange(A6:G1896)

rename UBIGEO_SIAF   ubigeo
rename E PIM_FIDT_2021
rename F PIM_FIDT_2022
rename G PIM_FIDT_2023

egen PIM_promedio_FIDT_mean = rowmean(PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023)

egen SUMA = rowtotal(PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023)

gen PIM_promedio_FIDT_all = SUMA/3

drop SUMA

keep  ubigeo PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023 PIM_promedio_FIDT_mean PIM_promedio_FIDT_all
order ubigeo PIM_FIDT_2021 PIM_FIDT_2022 PIM_FIDT_2023 PIM_promedio_FIDT_mean PIM_promedio_FIDT_all

unique ubigeo

save "$Output\PIM promedio FIDT.dta", replace

********************************************************************************
********************************************************************************
* PIM promedio por donaciones y Transferencia
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL_27_v2.xlsx", sheet("PIM DONACIONES") firstrow clear cellrange(A6:G1279)

rename UBIGEO_SIAF   ubigeo
rename E PIM_donaciones_2021
rename F PIM_donaciones_2022
rename G PIM_donaciones_2023

egen PIM_promedio_donaciones_mean = rowmean(PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023)

egen SUMA = rowtotal(PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023)

gen PIM_promedio_donaciones_all = SUMA/3

drop SUMA

keep  ubigeo PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023 PIM_promedio_donaciones_mean PIM_promedio_donaciones_all
order ubigeo PIM_donaciones_2021 PIM_donaciones_2022 PIM_donaciones_2023 PIM_promedio_donaciones_mean PIM_promedio_donaciones_all

unique ubigeo

save "$Output\PIM promedio donaciones y Transferencia.dta", replace

/*
********************************************************************************
********************************************************************************
* Porcentaje de ejecución promedio total
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL.xlsx", sheet("EJECUCION total") firstrow clear cellrange(A2:T2078)

rename UBIGEO_SIAF       ubigeo
rename ejecucionpromedio Ejecución_total

drop if DISTRITO=="99. MULTIDISTRITAL"

codebook  Ejecución_total ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023
mdesc     Ejecución_total ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023

br ubigeo Ejecución_total ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023 if Ejecución_total==.

egen Ejecución_total_imput = rowmean(ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023)

compare Ejecución_total Ejecución_total_imput

replace Ejecución_total=Ejecución_total_imput if Ejecución_total==.

keep  ubigeo Ejecución_total
order ubigeo Ejecución_total

save "$Output\Porcentaje de ejecución promedio total.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje de ejecución promedio de inversiones cuya función es subvencionada FIDT
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL.xlsx", sheet("EJECUCION FUNCION FIDT") firstrow clear cellrange(A2:T2071)

rename UBIGEO_SIAF       ubigeo
rename ejecucionpromedio Ejecución_FIDT

drop if DISTRITO=="99. MULTIDISTRITAL"

codebook  Ejecución_FIDT ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023
mdesc     Ejecución_FIDT ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023

br ubigeo Ejecución_FIDT ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023 if Ejecución_FIDT==.

egen Ejecución_FIDT_imput = rowmean(ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023)

compare Ejecución_FIDT Ejecución_FIDT_imput

replace Ejecución_FIDT=Ejecución_FIDT_imput if Ejecución_FIDT==.

keep  ubigeo Ejecución_FIDT
order ubigeo Ejecución_FIDT

save "$Output\Porcentaje de ejecución FIDT.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje de ejecución promedio de donaciones y transferencia
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MEF\Solicitud_FIDT_GRGL.xlsx", sheet("EJECUCION DONACIONES Y TRAN") firstrow clear cellrange(A2:T1469)

rename UBIGEO_SIAF       ubigeo
rename ejecucionpromedio Ejecución_donaciones

drop if DISTRITO=="99. MULTIDISTRITAL"

codebook  Ejecución_donaciones ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023
mdesc     Ejecución_donaciones ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023

br ubigeo Ejecución_donaciones ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023 if Ejecución_donaciones==.

egen Ejecución_donaciones_imput = rowmean(ejecucion2019 ejecucion2020 ejecucion2021 ejecucion2022 ejecucion2023)

compare Ejecución_donaciones Ejecución_donaciones_imput

replace Ejecución_donaciones=Ejecución_donaciones_imput if Ejecución_donaciones==.

keep  ubigeo Ejecución_donaciones
order ubigeo Ejecución_donaciones

save "$Output\Porcentaje de ejecución donaciones y transferencia.dta", replace
*/

********************************************************************************
********************************************************************************

use "$Ubigeo\UBIGEO 2022.dta", clear
merge 1:1 ubigeo using "$Output\PIM promedio total.dta", nogen
merge 1:1 ubigeo using "$Output\PIM promedio FIDT.dta", nogen
merge 1:1 ubigeo using "$Output\PIM promedio donaciones y Transferencia.dta", nogen

br if inlist(ubigeo, "030612", "050413", "050512", "050513", "050514", "050515", "080915", "080916", "080917") // 9 distritos 
br if inlist(ubigeo, "080918", "090724", "090725", "130112", "160109", "180107", "221006", "250306", "250307") // 9 distritos

mdesc

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\10. Recursos Presupuestales_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\10. Recursos Presupuestales.dta", replace




