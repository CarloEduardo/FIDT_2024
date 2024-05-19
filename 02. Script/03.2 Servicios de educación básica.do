* Tema: Servicios de educación básica (Parte 2)
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path   = "E:\01. DataBase\2. MINEDU\Censo Educativo"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\03. Servicios de educación básica"

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\31_Loc_Lineal_1\Loc_Lineal_1.dbf", clear

unique CODLOCAL // 67,546

keep   CODLOCAL CODGEO

rename CODGEO ubigeo

save "$Path\temp_ubigeo.dta", replace

*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\33_Loc_P101_Nivel\Loc_P101_Nivel.dbf", clear

unique CODLOCAL // 67,167

gen B0_F0 = cond(NIV_MOD=="B0" | NIV_MOD=="F0",1,0)

bys CODLOCAL: egen Primaria_secundaria = total(B0_F0)

keep CODLOCAL Primaria_secundaria

duplicates drop 

replace Primaria_secundaria = 1 if Primaria_secundaria>1

save "$Path\temp_pri_sec.dta", replace

*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Path\temp_ubigeo.dta", clear

merge 1:1 CODLOCAL using "$Path\temp_pri_sec.dta", nogen

save "$Path\temp.dta", replace

erase "$Path\temp_ubigeo.dta"
erase "$Path\temp_pri_sec.dta"

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de locales educativos que cuentan con al menos un aula acondicionada en estado de conservación de tipo bueno o regular.
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\32_Loc_Lineal_2\Loc_Lineal_2.dbf", clear

unique CODLOCAL // 64649

merge m:1 CODLOCAL using "$Path\temp.dta"

drop if _merge==2
drop if Primaria_secundaria==0

collapse (sum) Total_aulas=P501_1 Total_aulas_bueno=P501_2 Total_aulas_regular=P501_3 Total_aulas_malo=P501_4, by(ubigeo)	

gen P_aulas_bueno_regular =(Total_aulas_bueno+Total_aulas_regular)/Total_aulas
gen P_aulas_bueno  		  = Total_aulas_bueno/Total_aulas
gen P_aulas_regular       = Total_aulas_regular/Total_aulas
gen P_aulas_malo          = Total_aulas_malo/Total_aulas

save "$Output\LE aulas según estado de conservación.dta", replace

********************************************************************************
********************************************************************************
* v13 -> Porcentaje de locales educativos que cuentan con al menos una PC, Tablet y/o Laptop convencional.
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\48_Loc_P801_RecTec\Loc_P801_RecTec.dbf", clear

keep if CUADRO=="C801"

fre P801_1
/*
P801_1 -- P801_1
--------------------------------------------------------------------------------------------------
                                                     |      Freq.    Percent      Valid       Cum.
-----------------------------------------------------+--------------------------------------------
Valid   AURICULARES CON AUDIFONOS Y MICROFONO        |       2993       2.24       2.24       2.24
        CONSOLA DE AUDIO PARA LABORATORIO DE IDIOMAS |        890       0.67       0.67       2.91
        LAPTOP CONVENCIONAL                          |      21598      16.19      16.19      19.10
        LAPTOP XO                                    |      15890      11.91      11.91      31.02
        MICROSERVIDOR O HABILITADOR                  |        489       0.37       0.37      31.39
        PC DE ESCRITORIO                             |      31369      23.52      23.52      54.90
        PIZARRA INTERACTIVA                          |       2989       2.24       2.24      57.15
        PROYECTOR MULTIMEDIA                         |      25092      18.81      18.81      75.96
        SERVIDOR                                     |       6204       4.65       4.65      80.61
        TABLET - APRENDO EN CASA                     |      20161      15.12      15.12      95.73
        TABLET - OTROS                               |       2841       2.13       2.13      97.86
        TABLET - PRONATEL                            |       2859       2.14       2.14     100.00
        Total                                        |     133375     100.00     100.00           
--------------------------------------------------------------------------------------------------
*/

gen Sin_PC_Tablet_Laptop = 0 if regexm(P801_1,"TABLET|LAPTOP|PC DE ESCRITORIO")
replace Sin_PC_Tablet_Laptop = 1 if Sin_PC_Tablet_Laptop == .

collapse (sum) P801_2, by(CODLOCAL Sin_PC_Tablet_Laptop)

unique CODLOCAL // 45,564

bys CODLOCAL: egen Total_equipos = total(P801_2)
bys CODLOCAL: gen dupli = _N

gsort -dupli CODLOCAL

drop if dupli==2 & Sin_PC_Tablet_Laptop==0

unique CODLOCAL // 45,564

merge m:1 CODLOCAL using "$Path\temp.dta"

drop if _merge==2
drop if Primaria_secundaria==0

collapse (mean) Sin_PC_Tablet_Laptop (sum) Total_equipos, by(ubigeo)	

save "$Output\LE no Recursos Tecnológicos.dta", replace

********************************************************************************
********************************************************************************
* v14 -> Años de existencia de la infraestructura
********************************************************************************
********************************************************************************

********************************************************************************
********************************************************************************
* v15 -> Porcentaje de locales educativos inscritos en los Registros Públicos
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\36_Loc_P108_Safile\Loc_P108_Safile.dbf", clear

codebook

fre P108_5
/*
P108_5 -- P108_5
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   1     |      29266      41.05      41.05      41.05
        2     |      42020      58.95      58.95     100.00
        Total |      71286     100.00     100.00           
-----------------------------------------------------------
*/
destring P108_5, replace
recode P108_5 (2 = 1) (1 = 0), gen(No_Registros_Públicos_LE)

merge m:1 CODLOCAL using "$Path\temp.dta"

drop if _merge==2
drop if Primaria_secundaria==0

collapse (mean) No_Registros_Públicos_LE, by(ubigeo)	

save "$Output\LE no inscritos en los Registros Públicos.dta", replace

********************************************************************************
********************************************************************************
* v16 -> Porcentaje de locales educativos con el material predominante en las paredes del local educativo de Ladrillo o bloque de cemento y Piedra o sillar con cal o cemento
* v17 -> Porcentaje de locales educativos con el material predominante en el piso del local educativo de Parquet o madera pulida, Láminas asfálticas, vinílicos o similares, Losetas, terrazos, cerámicos o similares, Madera (pona, tornillo, etc.) y Cemento
* v18 -> Porcentaje de locales educativos con el material predominante en el techo del local educativo de Concreto armado, Madera, Tejas y Planchas de calamina, fibra de cemento o similares
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\44_Loc_P501_Aulas\Loc_P501_Aulas.dbf", clear

keep if CUADRO=="C501"

destring P501_12_1, replace // Paredes
recode P501_12_1 (3 4 5 6 7 8 9 = 1) (1 2 = 0), gen(No_paredes_aula_LE)

destring P501_13_1, replace // Techo
recode P501_13_1 (5 6 7 8 9 10 = 1) (1 2 3 4= 0), gen(No_techo_aula_LE)

destring P501_14_1, replace // Piso
recode P501_14_1 (5 6 7 = 1) (1 2 3 4= 0), gen(No_piso_aula_LE)

merge m:1 CODLOCAL using "$Path\temp.dta"
drop if Primaria_secundaria==0

drop if _merge==2

collapse (mean) No_paredes_aula_LE No_techo_aula_LE No_piso_aula_LE, by(ubigeo)	

save "$Output\LE según paredes, techo y pisos.dta", replace

********************************************************************************
********************************************************************************
* v19 -> Porcentaje de locales educativos con abastecimiento de agua del local educativo por Red pública, Red pública dentro de la vivienda, Red pública fuera de la vivienda, pero dentro de la edificación y Pilón o pileta de uso público
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\39_Loc_P200_ServBa\Loc_P200_ServBa.dbf", clear

keep if CUADRO=="C202"

destring NUMERO, replace
tab PREDOMIN NUMERO, miss
/*
                      |                                         NUMERO
             PREDOMIN |         1          2          3          4          5          6          7          8 |     Total
----------------------+----------------------------------------------------------------------------------------+----------
Cami�n cisterna u o.. |         0          0        795          0          0          0          0          0 |       795 
             No tiene |         0          0          0          0          0          0          0      2,811 |     2,811 
                 Otro |         0          0          0          0          0          0      5,272          0 |     5,272 
Pil�n de uso p�blic.. |         0      5,233          0          0          0          0          0          0 |     5,233 
                 Pozo |         0          0          0      4,606          0          0          0          0 |     4,606 
Red p�blica (agua p.. |    29,897          0          0          0          0          0          0          0 |    29,897 
R�o, acequia, manan.. |         0          0          0          0          0     12,382          0          0 |    12,382 
Sistema de Captaci�.. |         0          0          0          0      1,667          0          0          0 |     1,667 
----------------------+----------------------------------------------------------------------------------------+----------
                Total |    29,897      5,233        795      4,606      1,667     12,382      5,272      2,811 |    62,663 
*/
recode NUMERO (3 4 5 6 7 8 = 1) (1 2 = 0), gen(Sin_agua_LE)

merge m:1 CODLOCAL using "$Path\temp.dta"

drop if _merge==2
drop if Primaria_secundaria==0

collapse (mean) Sin_agua_LE, by(ubigeo)	

save "$Output\LE sin abastecimiento de agua.dta", replace

********************************************************************************
********************************************************************************
* v20 -> Porcentaje de locales educativos con eliminación de excretas del local educativo a través de Red pública de desagüe dentro del local educativo y Red pública de desagüe fuera del local educativo, pero dentro de la edificación
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\39_Loc_P200_ServBa\Loc_P200_ServBa.dbf", clear

keep if CUADRO=="C206"

destring NUMERO, replace
tab PREDOMIN NUMERO, miss
/*
                      |                                         NUMERO
             PREDOMIN |         1          2          3          4          5          6          7          8 |     Total
----------------------+----------------------------------------------------------------------------------------+----------
          Biodigestor |         0          0          0      4,083          0          0          0          0 |     4,083 
             No tiene |         0          0          0          0          0          0          0      7,064 |     7,064 
                 Otro |         0          0          0          0          0          0      1,520          0 |     1,520 
 Pozo sin tratamiento |         0          0          0          0      9,867          0          0          0 |     9,867 
          Red p�blica |    28,279          0          0          0          0          0          0          0 |    28,279 
 R�o, acequia o canal |         0      2,513          0          0          0          0          0          0 |     2,513 
       Tanque s�ptico |         0          0      8,439          0          0          0          0          0 |     8,439 
Unidades B�sicas de.. |         0          0          0          0          0        903          0          0 |       903 
----------------------+----------------------------------------------------------------------------------------+----------
                Total |    28,279      2,513      8,439      4,083      9,867        903      1,520      7,064 |    62,668 
*/
recode NUMERO (2 3 4 5 6 7 8 = 1) (1 = 0), gen(Sin_desagüe_LE)

merge m:1 CODLOCAL using "$Path\temp.dta"

drop if _merge==2
drop if Primaria_secundaria==0

collapse (mean) Sin_desagüe_LE, by(ubigeo)	

save "$Output\LE sin eliminación de excretas.dta", replace

********************************************************************************
********************************************************************************
* v21 -> Porcentaje de locales educativos con acceso al servicio de energía eléctrica del local educativo por Red pública de electricidad dentro del local educativo y Red pública de electricidad fuera del local educativo, pero dentro de la edificación
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\39_Loc_P200_ServBa\Loc_P200_ServBa.dbf", clear

keep if CUADRO=="C207"

destring NUMERO, replace
tab PREDOMIN NUMERO, miss
/*
                      |                                         NUMERO
             PREDOMIN |         1          2          3          4          5          6          7          8 |     Total
----------------------+----------------------------------------------------------------------------------------+----------
       Energ�a e�lica |         0          0          0          0          0         79          0          0 |        79 
Generador o motor d.. |         0          0        609          0          0          0          0          0 |       609 
Generador o motor d.. |         0        567          0          0          0          0          0          0 |       567 
Generador o motor d.. |         0          0          0        451          0          0          0          0 |       451 
             No tiene |         0          0          0          0          0          0          0      6,832 |     6,832 
                 Otro |         0          0          0          0          0          0      1,144          0 |     1,144 
          Panel solar |         0          0          0          0      2,445          0          0          0 |     2,445 
Red p�blica (de una.. |    50,544          0          0          0          0          0          0          0 |    50,544 
----------------------+----------------------------------------------------------------------------------------+----------
                Total |    50,544        567        609        451      2,445         79      1,144      6,832 |    62,671 
*/
recode NUMERO (8 = 1) (1 2 3 4 5 6 7 = 0), gen(Sin_electricidad_LE)

merge m:1 CODLOCAL using "$Path\temp.dta"

drop if _merge==2
drop if Primaria_secundaria==0

collapse (mean) Sin_electricidad_LE, by(ubigeo)	

save "$Output\LE sin energía eléctrica.dta", replace

********************************************************************************
********************************************************************************
* v22 -> Porcentaje promedio de aulas de clases que cuenta con el servicio eléctrico operativo; es decir, disponible en el momento oportuno de uso.
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\32_Loc_Lineal_2\Loc_Lineal_2.dbf", clear

fre P210 P211
destring P210, replace // Piso
recode P210 (2 = 1) (1 = 0), gen(No_servicio_eléctrico_LE)

merge m:1 CODLOCAL using "$Path\temp.dta"
drop if Primaria_secundaria==0

drop if _merge==2

collapse (mean) No_servicio_eléctrico_LE, by(ubigeo)	

save "$Output\LE servicio eléctrico operativo.dta", replace

********************************************************************************
********************************************************************************
* v23 -> Porcentaje de locales educativos que no cuentan con cerco perimétrico 
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\32_Loc_Lineal_2\Loc_Lineal_2.dbf", clear

unique CODLOCAL // 64,649

merge m:1 CODLOCAL using "$Path\temp.dta"

drop if _merge==2
drop if Primaria_secundaria==0

gen Cerco_perimétrico_total    = cond(P301=="1",1,0)
gen Cerco_perimétrico_parcial  = cond(P301=="2",1,0)
gen Cerco_perimétrico_no_tienes= cond(P301=="3",1,0)

collapse (sum) Cerco_perimétrico_total Cerco_perimétrico_parcial Cerco_perimétrico_no_tiene, by(ubigeo)	

save "$Output\LE cerco perimétrico.dta", replace

********************************************************************************
********************************************************************************
* v24 -> Cantidad de locales educativos
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import dbase using "$Path\33_Loc_P101_Nivel\Loc_P101_Nivel.dbf", clear

merge m:1 CODLOCAL using "$Path\temp.dta"

drop if _merge==2
drop if Primaria_secundaria==0

keep CODLOCAL ubigeo

unique CODLOCAL // 42,377

duplicates drop

unique CODLOCAL // 42,377

gen Cantidad_LE=1

collapse (sum) Cantidad_LE, by(ubigeo)	

save "$Output\Cantidad de locales educativos.dta", replace

********************************************************************************
********************************************************************************

use ubigeo P_aulas_bueno_regular using "$Output\LE aulas según estado de conservación.dta", replace

merge 1:1 ubigeo using "$Output\LE no Recursos Tecnológicos.dta", keepusing(Sin_PC_Tablet_Laptop) nogen
merge 1:1 ubigeo using "$Output\LE no inscritos en los Registros Públicos.dta", nogen
merge 1:1 ubigeo using "$Output\LE según paredes, techo y pisos.dta", nogen
merge 1:1 ubigeo using "$Output\LE sin abastecimiento de agua.dta", nogen
merge 1:1 ubigeo using "$Output\LE sin eliminación de excretas.dta", nogen
merge 1:1 ubigeo using "$Output\LE sin energía eléctrica.dta", nogen
merge 1:1 ubigeo using "$Output\LE servicio eléctrico operativo.dta", nogen
merge 1:1 ubigeo using "$Output\LE cerco perimétrico.dta", nogen
merge 1:1 ubigeo using "$Output\Cantidad de locales educativos.dta", nogen

* Imputation at the provincial level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
mdesc

gen id_reg_prov = substr(ubigeo,1,4)

bys id_reg_prov: egen P_aulas_bueno_regular_ip       = mean(P_aulas_bueno_regular)
bys id_reg_prov: egen Sin_PC_Tablet_Laptop_ip        = mean(Sin_PC_Tablet_Laptop) 
bys id_reg_prov: egen No_Registros_Públicos_LE_ip    = mean(No_Registros_Públicos_LE) 
bys id_reg_prov: egen No_paredes_aula_LE_ip          = mean(No_paredes_aula_LE) 
bys id_reg_prov: egen No_techo_aula_LE_ip            = mean(No_techo_aula_LE) 
bys id_reg_prov: egen No_piso_aula_LE_ip             = mean(No_piso_aula_LE) 
bys id_reg_prov: egen Sin_agua_LE_ip                 = mean(Sin_agua_LE) 
bys id_reg_prov: egen Sin_desagüe_LE_ip              = mean(Sin_desagüe_LE) 
bys id_reg_prov: egen Sin_electricidad_LE_ip         = mean(Sin_electricidad_LE) 
bys id_reg_prov: egen No_servicio_eléctrico_LE_ip    = mean(No_servicio_eléctrico_LE) 
bys id_reg_prov: egen Cerco_perimétrico_total_ip     = mean(Cerco_perimétrico_total) 
bys id_reg_prov: egen Cerco_perimétrico_parcial_ip   = mean(Cerco_perimétrico_parcial) 
bys id_reg_prov: egen Cerco_perimétrico_no_tienes_ip = mean(Cerco_perimétrico_no_tienes) 

replace P_aulas_bueno_regular       = P_aulas_bueno_regular_ip       if P_aulas_bueno_regular==.
replace Sin_PC_Tablet_Laptop        = Sin_PC_Tablet_Laptop_ip        if Sin_PC_Tablet_Laptop==.
replace No_Registros_Públicos_LE    = No_Registros_Públicos_LE_ip    if No_Registros_Públicos_LE==.
replace No_paredes_aula_LE          = No_paredes_aula_LE_ip          if No_paredes_aula_LE==.
replace No_techo_aula_LE            = No_techo_aula_LE_ip            if No_techo_aula_LE==.
replace No_piso_aula_LE             = No_piso_aula_LE_ip             if No_piso_aula_LE==.
replace Sin_agua_LE                 = Sin_agua_LE_ip                 if Sin_agua_LE==.
replace Sin_desagüe_LE              = Sin_desagüe_LE_ip              if Sin_desagüe_LE==.
replace Sin_electricidad_LE         = Sin_electricidad_LE_ip         if Sin_electricidad_LE==.
replace No_servicio_eléctrico_LE    = No_servicio_eléctrico_LE_ip    if No_servicio_eléctrico_LE==.
replace Cerco_perimétrico_total     = Cerco_perimétrico_total_ip     if Cerco_perimétrico_total==.
replace Cerco_perimétrico_parcial   = Cerco_perimétrico_parcial_ip   if Cerco_perimétrico_parcial==.
replace Cerco_perimétrico_no_tienes = Cerco_perimétrico_no_tienes_ip if Cerco_perimétrico_no_tienes==.

mdesc

drop id_reg_prov P_aulas_bueno_regular_ip Sin_PC_Tablet_Laptop_ip No_Registros_Públicos_LE_ip No_paredes_aula_LE_ip No_techo_aula_LE_ip No_piso_aula_LE_ip Sin_agua_LE_ip Sin_desagüe_LE_ip Sin_electricidad_LE_ip No_servicio_eléctrico_LE_ip Cerco_perimétrico_total_ip Cerco_perimétrico_parcial_ip Cerco_perimétrico_no_tienes_ip

save "$Output\03.2 Servicios de educación básica.dta", replace


