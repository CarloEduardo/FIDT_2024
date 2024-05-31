* Tema: Servicios de educación básica (Parte 2)
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path   = "E:\01. DataBase\FIDT"
global Minedu = "$Path\04. Minedu"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\03. Servicios de educación básica"

********************************************************************************
********************************************************************************
* Porcentaje Población que no tiene seguro de salud 
*
* Información extraida del OFICIO N° 000319-2024-INEI/JEF
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Minedu\Listado de LLEE Públicos y Privados 20052024.xlsx", sheet("RESUMEN_LOCALES") firstrow clear

rename codgeo ubigeo

* Filtering data
*'''''''''''''''
gen Inicial = regexm(Niveles, "Inicial")
gen Primaria = regexm(Niveles, "Primaria")
gen Secundaria = regexm(Niveles, "Secundaria")

gen ini_pri_sec = Inicial + Primaria + Secundaria

drop if ini_pri_sec==0

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de locales educativos con acceso al servicio de energía eléctrica en el local educativo por Red pública de electricidad dentro del local educativo y Red pública de electricidad fuera del local educativo, pero dentro de la edificación
********************************************************************************
********************************************************************************

fre electricidad_final
/*
electricidad_final -- electricidad_final
-------------------------------------------------------------------------------------------------------
                                                          |      Freq.    Percent      Valid       Cum.
----------------------------------------------------------+--------------------------------------------
Valid   1/ Red pública de electricidad dentro del local   |      48233      72.87      72.87      72.87
        educativo y Red pública de electricidad fuera del |                                            
        local educativo, pero dentro de la edificación    |                                            
        2/ Otros                                          |       5227       7.90       7.90      80.77
        3/ No tiene                                       |       6796      10.27      10.27      91.03
        4/ s.d.                                           |       5936       8.97       8.97     100.00
        Total                                             |      66192     100.00     100.00           
-------------------------------------------------------------------------------------------------------
*/
gen Sin_electricidad_LE = cond(electricidad_final=="1/ Red pública de electricidad dentro del local educativo y Red pública de electricidad fuera del local educativo, pero dentro de la edificación",0,1)
tab Sin_electricidad_LE, miss

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de locales educativos que cuentan con al menos un aula acondicionada en estado de conservación de tipo bueno o regular.
********************************************************************************
********************************************************************************

fre aula_acondicionada
/*
aula_acondicionada -- aula_acondicionada
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |       3297       4.98       4.98       4.98
        1     |      59768      90.29      90.29      95.28
        s.d.  |       3127       4.72       4.72     100.00
        Total |      66192     100.00     100.00           
-----------------------------------------------------------
*/
gen Sin_aula_acondicionada_LE = cond(aula_acondicionada=="1",0,1)
tab Sin_aula_acondicionada_LE, miss

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de locales educativos que cuentan con al menos una PC, Tablet y/o Laptop convencional.
********************************************************************************
********************************************************************************

fre al_menos_una_pc
/*
al_menos_una_pc -- al_menos_una_pc
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      30027      45.36      45.36      45.36
        1     |      36165      54.64      54.64     100.00
        Total |      66192     100.00     100.00           
-----------------------------------------------------------
*/
gen Sin_PC_Tablet_Laptop_LE = cond(al_menos_una_pc==1,0,1)
tab Sin_PC_Tablet_Laptop_LE, miss

********************************************************************************
********************************************************************************
* v12 -> Años de existencia de la infraestructura
********************************************************************************
********************************************************************************

gen Años_existencia_infra_LE = AÑOS_EXISTENCIA

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de locales educativos inscritos en los Registros Públicos
********************************************************************************
********************************************************************************

fre REGISTRO_PUBLICO
/*
REGISTRO_PUBLICO -- REGISTRO_PUBLICO
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      36542      55.21      55.21      55.21
        1     |      24776      37.43      37.43      92.64
        s.d.  |       4874       7.36       7.36     100.00
        Total |      66192     100.00     100.00           
-----------------------------------------------------------
*/
gen No_Registros_Públicos_LE = cond(REGISTRO_PUBLICO=="1",0,1)
tab No_Registros_Públicos_LE

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de locales educativos con el material predominante en las paredes del local educativo de Ladrillo o bloque de cemento y Piedra o sillar con cal o cemento
********************************************************************************
********************************************************************************
fre pared	
/*
pared -- pared
--------------------------------------------------------------------------------------------------------
                                                           |      Freq.    Percent      Valid       Cum.
-----------------------------------------------------------+--------------------------------------------
Valid   1/ Ladrillo o concreto                             |      32832      49.60      49.60      49.60
        2/ Adobe o tapia, Quincha, Piedra con barro, cal o |      18835      28.46      28.46      78.06
        cemento, Madera, Triplay, Eternit o fibra de       |                                            
        concreto, Estera, cartón o plástico, Otro material |                                            
        n.c.                                               |      12213      18.45      18.45      96.51
        s.d.                                               |       2312       3.49       3.49     100.00
        Total                                              |      66192     100.00     100.00           
--------------------------------------------------------------------------------------------------------
*/
gen No_paredes_aula_LE = cond(pared=="1/ Ladrillo o concreto",0,1)
tab No_paredes_aula_LE

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de locales educativos con el material predominante en el piso del local educativo de Parquet o madera pulida, Láminas asfálticas, vinílicos o similares, Losetas, terrazos, cerámicos o similares, Madera (pona, tornillo, etc.) y Cemento
********************************************************************************
********************************************************************************
fre pisos
/*
pisos -- pisos
-----------------------------------------------------------------------------------------------------
                                                        |      Freq.    Percent      Valid       Cum.
--------------------------------------------------------+--------------------------------------------
Valid   1/ Parquet o madera pulida, Vinilico, pisopak o |      50230      75.89      75.89      75.89
        similar, Loseta, cerámico o similar, Cemento,   |                                            
        Madera entablado                                |                                            
        2/ Tierra y Otro material                       |       1437       2.17       2.17      78.06
        n.c.                                            |      12213      18.45      18.45      96.51
        s.d.                                            |       2312       3.49       3.49     100.00
        Total                                           |      66192     100.00     100.00           
-----------------------------------------------------------------------------------------------------
*/
gen No_piso_aula_LE = cond(pisos=="1/ Parquet o madera pulida, Vinilico, pisopak o similar, Loseta, cerámico o similar, Cemento, Madera entablado",0,1)
tab No_piso_aula_LE, miss

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de locales educativos con el material predominante en el techo del local educativo de Concreto armado, Madera, Tejas y Planchas de calamina, fibra de cemento o similares
********************************************************************************
********************************************************************************
fre techo
/*
techo -- techo
-----------------------------------------------------------------------------------------------------
                                                        |      Freq.    Percent      Valid       Cum.
--------------------------------------------------------+--------------------------------------------
Valid   1/ Concreto armado, Madera, Teja, Fibra de      |      51593      77.94      77.94      77.94
        cemento, Calamina, Calaminón, Eternit           |                                            
        2/ Caña con barro, Lata o latón y Otro material |         74       0.11       0.11      78.06
        n.c.                                            |      12213      18.45      18.45      96.51
        s.d.                                            |       2312       3.49       3.49     100.00
        Total                                           |      66192     100.00     100.00           
-----------------------------------------------------------------------------------------------------
*/
gen No_techo_aula_LE = cond(techo=="1/ Concreto armado, Madera, Teja, Fibra de cemento, Calamina, Calaminón, Eternit",0,1)
tab No_techo_aula_LE, miss

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de locales educativos con abastecimiento de agua del local educativo por Red pública, Red pública dentro de la vivienda, Red pública fuera de la vivienda, pero dentro de la edificación y Pilón o pileta de uso público
********************************************************************************
********************************************************************************
fre agua_final
/*
agua_final -- agua_final
-------------------------------------------------------------------------------------------------------
                                                          |      Freq.    Percent      Valid       Cum.
----------------------------------------------------------+--------------------------------------------
Valid   1/ Red pública, Red pública dentro del local      |      33011      49.87      49.87      49.87
        educativo, Red pública fuera del local educativo, |                                            
        pero dentro de la edificación y Pilón o pileta de |                                            
        uso público                                       |                                            
        2/ Otros                                          |      24452      36.94      36.94      86.81
        3/ No tiene                                       |       2786       4.21       4.21      91.02
        4/ s.d.                                           |       5943       8.98       8.98     100.00
        Total                                             |      66192     100.00     100.00           
-------------------------------------------------------------------------------------------------------
*/
gen Sin_agua_LE = cond(agua_final=="1/ Red pública, Red pública dentro del local educativo, Red pública fuera del local educativo, pero dentro de la edificación y Pilón o pileta de uso público",0,1)
tab Sin_agua_LE, miss

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de locales educativos con eliminación de excretas del local educativo a través de Red pública de desagüe dentro del local educativo y Red pública de desagüe fuera del local educativo, pero dentro de la edificación
********************************************************************************
********************************************************************************

fre desague_final
/*
desague_final -- desague_final
--------------------------------------------------------------------------------------------------------
                                                           |      Freq.    Percent      Valid       Cum.
-----------------------------------------------------------+--------------------------------------------
Valid   1/ Red pública de desague dentro del local         |      26161      39.52      39.52      39.52
        educativo y Red pública de desague fuera del local |                                            
        educativo, pero dentro de la edificación           |                                            
        2/ Pozo séptico, tanque séptico o biodigestor,     |      27068      40.89      40.89      80.42
        Letrina (con tratamiento), Pozo ciego o negro,     |                                            
        Río, acequia, canal o similar, Campo abierto o al  |                                            
        aire libre y Otro                                  |                                            
        3/ No tiene                                        |       7025      10.61      10.61      91.03
        4/ s.d.                                            |       5938       8.97       8.97     100.00
        Total                                              |      66192     100.00     100.00           
--------------------------------------------------------------------------------------------------------
*/
gen Sin_desagüe_LE = cond(desague_final=="1/ Red pública de desague dentro del local educativo y Red pública de desague fuera del local educativo, pero dentro de la edificación",0,1)
tab Sin_desagüe_LE, miss

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de locales educativos que no cuentan con cerco perimétrico 
********************************************************************************
********************************************************************************

fre cercoperimetrico
/*

cercoperimetrico -- cercoperimetrico
--------------------------------------------------------------
                 |      Freq.    Percent      Valid       Cum.
-----------------+--------------------------------------------
Valid   No tiene |      26059      37.79      37.79      37.79
        Parcial  |      11368      16.49      16.49      54.28
        Total    |      27222      39.48      39.48      93.75
        s.d.     |       4308       6.25       6.25     100.00
        Total    |      68957     100.00     100.00           
--------------------------------------------------------------

*/
gen Cerco_perimétrico_total    = cond(cercoperimetrico=="Total",1,0) if cercoperimetrico!="s.d."
gen Cerco_perimétrico_parcial  = cond(cercoperimetrico=="Parcial",1,0) if cercoperimetrico!="s.d."
gen Cerco_perimétrico_no_tienes= cond(cercoperimetrico=="No tiene",1,0) if cercoperimetrico!="s.d."

tab Cerco_perimétrico_total, miss
tab Cerco_perimétrico_parcial, miss
tab Cerco_perimétrico_no_tienes, miss

********************************************************************************
********************************************************************************
* v12 -> Cantidad de locales educativos
********************************************************************************
********************************************************************************
gen Cantidad_LE = 1

********************************************************************************
********************************************************************************
* v12 -> Porcentaje de instituciones educativas a nivel _ en condiciones inadecuadas
* v12 -> Porcentaje de instituciones educativas a nivel primario en condiciones inadecuadas
* v12 -> Porcentaje de instituciones educativas a nivel secundario en condiciones inadecuadas
********************************************************************************
********************************************************************************
fre condiciones_inadecuadas
/*
condiciones_inadecuadas -- condiciones_inadecuadas
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |      23170      35.00      35.00      35.00
        1     |      37086      56.03      56.03      91.03
        s.d.  |       5936       8.97       8.97     100.00
        Total |      66192     100.00     100.00           
-----------------------------------------------------------
*/
gen cond_inadecuadas_inicial = cond(condiciones_inadecuadas=="1",0,1) if regexm(Niveles, "Inicial")
gen cond_inadecuadas_primaria = cond(condiciones_inadecuadas=="1",0,1) if regexm(Niveles, "Primaria")
gen cond_inadecuadas_secundaria = cond(condiciones_inadecuadas=="1",0,1) if regexm(Niveles, "Secundaria")

collapse (mean) Sin_electricidad_LE Sin_aula_acondicionada_LE Sin_PC_Tablet_Laptop_LE Años_existencia_infra_LE No_Registros_Públicos_LE No_paredes_aula_LE No_piso_aula_LE No_techo_aula_LE Sin_agua_LE Sin_desagüe_LE Cerco_perimétrico_total Cerco_perimétrico_parcial Cerco_perimétrico_no_tienes (sum) Cantidad_LE (mean) cond_inadecuadas_inicial cond_inadecuadas_primaria cond_inadecuadas_secundaria, by(ubigeo Departamento Provincia Distrito)	

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\03.2 Servicios de educación básica_all.dta", replace

drop Departamento Provincia Distrito

save "$Output\03.2 Servicios de educación básica.dta", replace


