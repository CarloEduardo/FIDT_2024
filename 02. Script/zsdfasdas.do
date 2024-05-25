* Tema: RENIPRESS y Salud Básica
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path       = "E:\01. DataBase\FIDT"
global Ubigeo     = "$Path\00. Ubigeo"
global Censo_2017 = "$Path\01. Censo 2017"
global Susalud 	  = "$Path\SUSALUD"
global Output     = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\01. Salud Básica"

********************************************************************************
********************************************************************************
* Cantidad de establecimientos de salud del Sector Público
*
* Información extraida de la web de SUSALUD
* http://app20.susalud.gob.pe:8080/registro-renipress-webapp/listadoEstablecimientosRegistrados.htm?action=mostrarBuscar#no-back-button
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Susalud\USLRC20240513113548_xp.xls", sheet("Listado de Establecimientos") firstrow clear

rename UBIGEO ubigeo 

* Filtering data
*'''''''''''''''

fre Tipo
keep if Tipo=="ESTABLECIMIENTO DE SALUD CON INTERNAMIENTO" | Tipo=="ESTABLECIMIENTO DE SALUD SIN INTERNAMIENTO"

fre Categoria
drop if Categoria=="Sin Categoría"

gen RENIPRESS=1
collapse (sum) RENIPRESS, by(ubigeo Institución)

encode Institución, generate(Institución_label)

fre Institución_label
/*
Institución_label -- Institución
------------------------------------------------------------------------------------------------
                                                   |      Freq.    Percent      Valid       Cum.
---------------------------------------------------+--------------------------------------------
Valid   1  ESSALUD                                 |        329      10.92      10.92      10.92
        2  GOBIERNO REGIONAL                       |       1823      60.50      60.50      71.42
        3  INPE                                    |         50       1.66       1.66      73.08
        4  MINSA                                   |        106       3.52       3.52      76.60
        5  MUNICIPALIDAD DISTRITAL                 |         19       0.63       0.63      77.23
        6  MUNICIPALIDAD PROVINCIAL                |         34       1.13       1.13      78.36
        7  OTRO                                    |         67       2.22       2.22      80.58
        8  PRIVADO                                 |        358      11.88      11.88      92.47
        9  SANIDAD DE LA FUERZA AEREA DEL PERU     |         23       0.76       0.76      93.23
        10 SANIDAD DE LA MARINA DE GUERRA DEL PERU |         19       0.63       0.63      93.86
        11 SANIDAD DE LA POLICIA NACIONAL DEL PERU |         76       2.52       2.52      96.38
        12 SANIDAD DEL EJERCITO DEL PERU           |        109       3.62       3.62     100.00
        Total                                      |       3013     100.00     100.00           
------------------------------------------------------------------------------------------------
*/

drop Institución

reshape wide RENIPRESS, i(ubigeo) j(Institución_label)

rename RENIPRESS1  RENIPRESS_ESSALUD
rename RENIPRESS2  RENIPRESS_GOBIERNO_REGIONAL
rename RENIPRESS3  RENIPRESS_INPE
rename RENIPRESS4  RENIPRESS_MINSA
rename RENIPRESS5  RENIPRESS_MUNI_DISTRITAL
rename RENIPRESS6  RENIPRESS_MUNI_PROVINCIAL
rename RENIPRESS7  RENIPRESS_OTRO
rename RENIPRESS8  RENIPRESS_PRIVADO
rename RENIPRESS9  RENIPRESS_FUERZA_AEREA
rename RENIPRESS10 RENIPRESS_MARINA_GUERRA
rename RENIPRESS11 RENIPRESS_POLICIA_NACIONAL
rename RENIPRESS12 RENIPRESS_EJERCITO

foreach var of varlist RENIPRESS_ESSALUD RENIPRESS_GOBIERNO_REGIONAL RENIPRESS_INPE RENIPRESS_MINSA RENIPRESS_MUNI_DISTRITAL RENIPRESS_MUNI_PROVINCIAL RENIPRESS_OTRO RENIPRESS_PRIVADO RENIPRESS_FUERZA_AEREA RENIPRESS_MARINA_GUERRA RENIPRESS_POLICIA_NACIONAL RENIPRESS_EJERCITO {
	replace `var' = 0 if `var' == .
}

gen Establecimientos_salud_SP= RENIPRESS_ESSALUD + RENIPRESS_GOBIERNO_REGIONAL + RENIPRESS_MINSA + RENIPRESS_MUNI_DISTRITAL + RENIPRESS_MUNI_PROVINCIAL

save "$Output\RENIPRESS.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje de población con alguna dificultad permanente
*
* Información extraida de la web de INEI
* https://censos2017.inei.gob.pe/redatam/
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Censo_2017\cpv2017_pob.dta", clear

gen ubigeo = ccdd + ccpp + ccdi

d c5_p9_*
/*
              storage   display    value
variable name   type    format     label      variable label
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
c5_p9_1         byte    %8.0g      c5_p9_1    p: población con discapacidad: ver
c5_p9_2         byte    %8.0g      c5_p9_2    p: población con discapacidad: oír
c5_p9_3         byte    %8.0g      c5_p9_3    p: población con discapacidad: hablar
c5_p9_4         byte    %8.0g      c5_p9_4    p: población con discapacidad: moverse o caminar para usar brazos y piernas
c5_p9_5         byte    %8.0g      c5_p9_5    p: población con discapacidad: entender o aprender
c5_p9_6         byte    %8.0g      c5_p9_6    p: población con discapacidad: relacionarse con los demás
c5_p9_7         byte    %8.0g      c5_p9_7    p: población con discapacidad: ninguna
*/

mdesc c5_p9_*
/*
    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
        c5_p9_1 |           0       29381884           0.00
        c5_p9_2 |           0       29381884           0.00
        c5_p9_3 |           0       29381884           0.00
        c5_p9_4 |           0       29381884           0.00
        c5_p9_5 |           0       29381884           0.00
        c5_p9_6 |           0       29381884           0.00
        c5_p9_7 |           0       29381884           0.00
----------------+-----------------------------------------------
*/

egen Población_con_discapacidad =rowtotal(c5_p9_1 c5_p9_2 c5_p9_3 c5_p9_4 c5_p9_5 c5_p9_6)
gen  P_Con_discapacidad = cond(Población_con_discapacidad>0,1,0)

collapse (mean) P_Con_discapacidad [iw=factor_pond], by(ubigeo)

save "$Output\Con discapacidad.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje Población que no tiene seguro de salud 
*
* Información extraida del OFICIO N° 000319-2024-INEI/JEF
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Censo_2017\INFORMACION MEF REG. 7922.xlsx", sheet("SEGURO_DIST") clear cellrange(B8:O1898)

rename B ubigeo	
rename C Distrito
rename D Total
rename E Sin_seguro
rename F Con_seguro
rename G Con_más_un_seguro
rename H Total_urbano
rename I Sin_seguro_urbano
rename J Con_seguro_urbano
rename K Con_más_un_seguro_urbano
rename L Total_rural
rename M Sin_seguro_rural
rename N Con_seguro_rural
rename O Con_más_un_seguro_rural

gen P_Sin_seguro = Sin_seguro / Total

keep ubigeo P_Sin_seguro

save "$Output\Sin seguro.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************

use "$Ubigeo\UBIGEO 2022.dta", clear

merge 1:1 ubigeo using "$Output\RENIPRESS.dta", nogen
merge 1:1 ubigeo using "$Output\Sin seguro.dta", nogen
merge 1:1 ubigeo using "$Output\Con discapacidad.dta", nogen

keep  ubigeo REGION PROVINCIA DISTRITO Establecimientos_salud_SP P_Con_discapacidad P_Sin_seguro 
order ubigeo REGION PROVINCIA DISTRITO Establecimientos_salud_SP P_Con_discapacidad P_Sin_seguro

mdesc
 
sort ubigeo
br if P_Con_discapacidad==.

* Imputation 
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

* Apurímac - Chincheros
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
summarize P_Con_discapacidad if ubigeo == "030604"
local v01 = r(mean)
replace P_Con_discapacidad = `v01' if ubigeo == "030612" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "030604"
local v01 = r(mean)
replace Establecimientos_salud_SP = `v01' if ubigeo == "030612" & Establecimientos_salud_SP == .

br if ubigeo == "030604" | ubigeo == "030612"

* Ayacucho - Huanta
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
summarize P_Con_discapacidad if ubigeo == "050406"
local v02 = r(mean)
replace P_Con_discapacidad = `v02' if ubigeo == "050413" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "050406"
local v02 = r(mean)
replace Establecimientos_salud_SP = `v02' if ubigeo == "050413" & Establecimientos_salud_SP == .

br if ubigeo == "050406" | ubigeo == "050413"

* Ayacucho - La Mar
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
summarize P_Con_discapacidad if ubigeo == "050502"
local v03 = r(mean)
replace P_Con_discapacidad = `v03' if ubigeo == "050512" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "050502"
local v03 = r(mean)
replace Establecimientos_salud_SP = `v03' if ubigeo == "050512" & Establecimientos_salud_SP == .

br if ubigeo == "050502" | ubigeo == "050512"

summarize P_Con_discapacidad if ubigeo == "050503"
local v04 = r(mean)
replace P_Con_discapacidad = `v04' if ubigeo == "050513" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "050503"
local v04 = r(mean)
replace Establecimientos_salud_SP = `v04' if ubigeo == "050513" & Establecimientos_salud_SP == .

br if ubigeo == "050503" | ubigeo == "050513"

summarize P_Con_discapacidad if ubigeo == "050501"
local v05 = r(mean)
local v06 = r(mean)
replace P_Con_discapacidad = `v05' if ubigeo == "050514" & P_Con_discapacidad == .
replace P_Con_discapacidad = `v06' if ubigeo == "050515" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "050501"
local v05 = r(mean)
local v06 = r(mean)
replace Establecimientos_salud_SP = `v05' if ubigeo == "050514" & Establecimientos_salud_SP == .
replace Establecimientos_salud_SP = `v06' if ubigeo == "050515" & Establecimientos_salud_SP == .

br if ubigeo == "050501" | ubigeo == "050514" | ubigeo == "050515"

* Cusco - La Convención
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
summarize P_Con_discapacidad if ubigeo == "080902" | ubigeo == "080909"
local v07 = r(mean)
replace P_Con_discapacidad = `v07' if ubigeo == "080915" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "080902" | ubigeo == "080909"
local v07 = r(mean)
replace Establecimientos_salud_SP = `v07' if ubigeo == "080915" & Establecimientos_salud_SP == .

br if ubigeo == "080902" | ubigeo == "080909" | ubigeo == "080915"

summarize P_Con_discapacidad if ubigeo == "080907"
local v08 = r(mean)
local v09 = r(mean)
replace P_Con_discapacidad = `v08' if ubigeo == "080916" & P_Con_discapacidad == .
replace P_Con_discapacidad = `v09' if ubigeo == "080917" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "080907"
local v08 = r(mean)
local v09 = r(mean)
replace Establecimientos_salud_SP = `v08' if ubigeo == "080916" & Establecimientos_salud_SP == .
replace Establecimientos_salud_SP = `v09' if ubigeo == "080917" & Establecimientos_salud_SP == .

br if ubigeo == "080907" | ubigeo == "080916" | ubigeo == "080917"

summarize P_Con_discapacidad if ubigeo == "080910"
local v10 = r(mean)
replace P_Con_discapacidad = `v10' if ubigeo == "080918" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "080910"
local v10 = r(mean)
replace Establecimientos_salud_SP = `v10' if ubigeo == "080918" & Establecimientos_salud_SP == .

br if ubigeo == "080910" | ubigeo == "080918"

* Huancavelica - Tayacaja
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
summarize P_Con_discapacidad if ubigeo == "090707" | ubigeo == "090717"
local v11 = r(mean)
replace P_Con_discapacidad = `v11' if ubigeo == "090724" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "090707" | ubigeo == "090717"
local v11 = r(mean)
replace Establecimientos_salud_SP = `v11' if ubigeo == "090724" & Establecimientos_salud_SP == .

br if ubigeo == "090707" | ubigeo == "090717" | ubigeo == "090724"

summarize P_Con_discapacidad if ubigeo == "090718"
local v12 = r(mean)
replace P_Con_discapacidad = `v12' if ubigeo == "090725" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "090718"
local v12 = r(mean)
replace Establecimientos_salud_SP = `v12' if ubigeo == "090725" & Establecimientos_salud_SP == .

br if ubigeo == "090718" | ubigeo == "090725"

* La Libertad - Trujillo
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
summarize P_Con_discapacidad if ubigeo == "130106"
local v13 = r(mean)
replace P_Con_discapacidad = `v13' if ubigeo == "130112" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "130106"
local v13 = r(mean)
replace Establecimientos_salud_SP = `v13' if ubigeo == "130112" & Establecimientos_salud_SP == .

br if ubigeo == "130106" | ubigeo == "130112"

* Moquegua - Mariscal Nieto
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
summarize P_Con_discapacidad if ubigeo == "180101"
local v14 = r(mean)
replace P_Con_discapacidad = `v14' if ubigeo == "180107" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "180101"
local v14 = r(mean)
replace Establecimientos_salud_SP = `v14' if ubigeo == "180107" & Establecimientos_salud_SP == .

br if ubigeo == "180101" | ubigeo == "180107"

* San Martín - Tocache
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
summarize P_Con_discapacidad if ubigeo == "221005"
local v15 = r(mean)
replace P_Con_discapacidad = `v15' if ubigeo == "221006" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "221005"
local v15 = r(mean)
replace Establecimientos_salud_SP = `v15' if ubigeo == "221006" & Establecimientos_salud_SP == .

br if ubigeo == "221005" | ubigeo == "221006"

* Ucayali - Padre Abad
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
summarize P_Con_discapacidad if ubigeo == "250301" | ubigeo == "250303" | ubigeo == "250304" | ubigeo == "250305"
local v16 = r(mean)
local v17 = r(mean)
replace P_Con_discapacidad = `v16' if ubigeo == "250306" & P_Con_discapacidad == .
replace P_Con_discapacidad = `v17' if ubigeo == "250307" & P_Con_discapacidad == .

summarize Establecimientos_salud_SP if ubigeo == "250301" | ubigeo == "250303" | ubigeo == "250304" | ubigeo == "250305"
local v16 = r(mean)
local v17 = r(mean)
replace Establecimientos_salud_SP = `v16' if ubigeo == "250306" & Establecimientos_salud_SP == .
replace Establecimientos_salud_SP = `v17' if ubigeo == "250307" & Establecimientos_salud_SP == .

br if ubigeo == "250301" | ubigeo == "250303" | ubigeo == "250304" | ubigeo == "250305" | ubigeo == "250306" | ubigeo == "250307"

mdesc

* Imputation at the provincial level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
mdesc

gen id_reg_prov = substr(ubigeo,1,4)

bys id_reg_prov: egen Establecimientos_salud_SP_ip = mean(Establecimientos_salud_SP)

replace Establecimientos_salud_SP = Establecimientos_salud_SP_ip if Establecimientos_salud_SP==.

drop id_reg_prov Establecimientos_salud_SP_ip

mdesc

/*
* Imputation at the provincial level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
mdesc

gen id_reg_prov = substr(ubigeo,1,4)

bys id_reg_prov: egen Establecimientos_salud_SP_ip = mean(Establecimientos_salud_SP)
bys id_reg_prov: egen Con_discapacidad_ip          = mean(Con_discapacidad)
bys id_reg_prov: egen Sin_seguro_ip                = mean(Sin_seguro)

replace Establecimientos_salud_SP = Establecimientos_salud_SP_ip if Establecimientos_salud_SP==.
replace Con_discapacidad          = Con_discapacidad_ip          if Con_discapacidad==.
replace Sin_seguro                = Sin_seguro_ip                if Sin_seguro==.

drop id_reg_prov Con_discapacidad_ip Sin_seguro_ip

mdesc

* Imputation at the regional level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
mdesc

gen id_reg = substr(ubigeo,1,2)

bys id_reg: egen Establecimientos_salud_SP_ir = mean(Establecimientos_salud_SP)
bys id_reg: egen Con_discapacidad_ir          = mean(Con_discapacidad)
bys id_reg: egen Sin_seguro_ir                = mean(Sin_seguro)

replace Con_discapacidad = Con_discapacidad_ir if Con_discapacidad==.
replace Sin_seguro       = Sin_seguro_ir       if Sin_seguro==.

drop id_reg Con_discapacidad_ir Sin_seguro_ir

mdesc
*/

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\01. Salud Básica_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\01. Salud Básica.dta", replace
