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
gen  Con_discapacidad = cond(Población_con_discapacidad>0,1,0)
gen  Población = 1

collapse (mean) Con_discapacidad (sum) Población [iw=factor_pond], by(ubigeo codccpp)

bys ubigeo: egen NNN = total(Población)

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

keep ubigeo Distrito P_Sin_seguro Total Total_urbano Total_rural

save "$Output\Sin seguro.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************

use "$Ubigeo\UBIGEO 2022.dta", clear // 1,891
use "$Output\RENIPRESS.dta", clear // 1,875
use "$Output\Sin seguro.dta", clear // 1,891
use "$Output\Con discapacidad.dta", clear // 1,874


use "$Output\Con discapacidad.dta" , clear
merge m:1 ubigeo using "$Output\Sin seguro.dta" 

gen id_reg_prov = substr(ubigeo,1,4)

replace NNN       = round(NNN)
replace Total     = round(Total)
replace Población = round(Población)

* Apurímac - Chincheros
* 030604 --> 030612
br if id_reg_prov=="0306" & NNN!=Total

* Ayacucho - Huanta
* 050406 --> 050413
br if id_reg_prov=="0504" & NNN!=Total

* Ayacucho - La Mar
* 050502 --> 050512
* 050503 --> 050513
* 050501 --> 050514
* 050501 --> 050515
br if id_reg_prov=="0505" & NNN!=Total
br if id_reg_prov=="0505" & NNN!=Total
br if id_reg_prov=="0505" & NNN!=Total
br if id_reg_prov=="0505" & NNN!=Total

* Cusco - La Convención
* 080902 --> 080915
* 080909 --> 080915
* 080907 --> 080916
* 080907 --> 080917
* 080910 --> 080918
br if id_reg_prov=="0809" & NNN!=Total
br if id_reg_prov=="0809" & NNN!=Total
br if id_reg_prov=="0809" & NNN!=Total
br if id_reg_prov=="0809" & NNN!=Total

* Huancavelica - Tayacaja
* 090707 --> 090724
* 090717 --> 090724
* 090718 --> 090725
display 3387-2431
br if id_reg_prov=="0907" & NNN!=Total
br if id_reg_prov=="0907" & NNN!=Total

* La Libertad - Trujillo
* 130106 --> 130112
br if id_reg_prov=="1301" & NNN!=Total

* Moquegua - Mariscal Nieto
* 180101 --> 180107
br if id_reg_prov=="1801" & NNN!=Total

* San Martín - Tocache
* 221005 --> 221006
br if id_reg_prov=="2210" & NNN!=Total

* Ucayali - Padre Abad
* 250301 -- 250303 -- 250304 -- 250305 --> 250306 - 250307
br if id_reg_prov=="2503" & NNN!=Total
br if id_reg_prov=="2503" & NNN!=Total

NNN	Total
display 6979-5805


compare NNN Total
br if NNN!=Total

unique ubigeo if _merge==3 & NNN!=Total

matched (3)
matched (3)

35867.999	35867.999
35867.999	35867.999

ubigeo
030612
050413
050512
050513
050514
050515
080915
080916
080917
080918
090724
090725
130112
180107
221006
250306
250307


, nogen


use "$Ubigeo\00. Ubigeo\UBIGEO 2022.dta", clear

merge 1:1 ubigeo using "$Output\RENIPRESS.dta", nogen
merge 1:1 ubigeo using "$Output\Sin seguro.dta", nogen
merge 1:1 ubigeo using "$Output\Con discapacidad.dta", nogen

keep  ubigeo REGION PROVINCIA DISTRITO Establecimientos_salud_SP Con_discapacidad Sin_seguro 
order ubigeo REGION PROVINCIA DISTRITO Establecimientos_salud_SP Con_discapacidad Sin_seguro

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
/*
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
