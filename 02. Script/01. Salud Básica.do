* Tema: RENIPRESS y Salud Básica
* Elaboracion: Carlos Torres
* Link RENIPRESS: 
* http://app20.susalud.gob.pe:8080/registro-renipress-webapp/listadoEstablecimientosRegistrados.htm?action=mostrarBuscar#no-back-button
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path   = "E:\01. DataBase\1. INEI\5 CVP 2017"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\01. Salud Básica"

********************************************************************************
********************************************************************************
* Cantidad de establecimientos de salud del Sector Público
********************************************************************************
********************************************************************************
/*
Esta variable hace referencia a conocer la cantidad de establecimientos de salud del sector público a nivel nacional que sean administrados por el MINSA, ESSALUD, Gobiernos Locales, Gobiernos Regionales de tipo establecimiento de salud con y sin internamiento que cuente con alguna categoría establecida por el MINSA, identificando así brechas de infraestructura. 
*/

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Output\USLRC20240514033045_xp.xls", sheet("Listado de Establecimientos") firstrow clear

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
* Porcentaje de población que no tiene seguro de salud 
********************************************************************************
********************************************************************************
/*
Esta variable busca conocer el porcentaje de la población que cuenta con alguna dificultad permanente para ver, oír, hablar/comunicarse, moverse/caminar, entender/aprender o relacionarse con los demás por sus pensamientos, sentimientos, emociones o conductas y que necesitan infraestructura en salud adecuado para un correcto tratamiento.

Con esta variable podremos conocer el porcentaje de personas que no cuenta con algún seguro de salud, lo cual puede deberse por la escasa oferta de infraestructura de salud.
*/

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Path\cpv2017_pob.dta", clear

gen ubigeo = ccdd + ccpp + ccdi

* Filtering data
*'''''''''''''''

fre thogar // thogar -- p: total de hogares 
br   if thogar=="99"
drop if thogar=="99"

d c5_p8_*
/*
              storage   display    value
variable name   type    format     label      variable label
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
c5_p8_1         byte    %8.0g      c5_p8_1    p: población afiliada: al sis
c5_p8_2         byte    %8.0g      c5_p8_2    p: población afiliada: a essalud
c5_p8_3         byte    %8.0g      c5_p8_3    p: población afiliada: a seguro de fuerzas armadas o policiales
c5_p8_4         byte    %8.0g      c5_p8_4    p: población afiliada: a seguro privado de salud
c5_p8_5         byte    %8.0g      c5_p8_5    p: población afiliada: a otro seguro
c5_p8_6         byte    %8.0g      c5_p8_6    p: población afiliada: a ningún seguro
*/
egen Población_sin_seguro       =rowtotal(c5_p8_1 c5_p8_2 c5_p8_3 c5_p8_4 c5_p8_5)
gen  Sin_seguro = cond(Población_sin_seguro>0,1,0)

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
egen Población_con_discapacidad =rowtotal(c5_p9_1 c5_p9_2 c5_p9_3 c5_p9_4 c5_p9_5 c5_p9_6)
gen  Con_discapacidad = cond(Población_con_discapacidad>0,1,0)

collapse (mean) Sin_seguro Con_discapacidad [iw=factor_pond], by(ubigeo)

foreach var of varlist Sin_seguro Con_discapacidad {
	replace `var' = 0 if `var' == .
}

save "$Output\Sin seguro y con discapacidad.dta", replace

********************************************************************************
********************************************************************************

use "$Output\RENIPRESS.dta", replace

merge 1:1 ubigeo using "$Output\Sin seguro y con discapacidad.dta"

tab _merge, miss
/*
                 _merge |      Freq.     Percent        Cum.
------------------------+-----------------------------------
        master only (1) |          3        0.16        0.16
         using only (2) |          2        0.11        0.27
            matched (3) |      1,872       99.73      100.00
------------------------+-----------------------------------
                  Total |      1,877      100.00
*/

keep  ubigeo Establecimientos_salud_SP Con_discapacidad Sin_seguro 
order ubigeo Establecimientos_salud_SP Con_discapacidad Sin_seguro

save "$Output\01 Salud Básica.dta", replace
