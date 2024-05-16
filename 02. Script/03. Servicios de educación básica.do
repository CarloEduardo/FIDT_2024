* Tema: Servicios de educación básica
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path   = "E:\01. DataBase\1. INEI\5 CVP 2017"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\03. Servicios de educación básica"

********************************************************************************
********************************************************************************
* Porcentaje Personas que no saben leer ni escribir 
* Porcentaje población que asiste una IE en otro distrito
* Porcentaje personas de 15 a más años con nivel alcanzado mínimo de secundario
* Años promedios de escolaridad de 3 a 17 años
* Porcentaje de Hogar con niños que no estudian (de 6 a 12 años)
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Path\cpv2017_pob.dta", clear

gen ubigeo = ccdd + ccpp + ccdi

* Filtering data
*'''''''''''''''

fre thogar // thogar -- p: total de hogares 
br   if thogar=="99"
drop if thogar=="99"

fre c5_p12
/*
c5_p12 -- p3a+: sabe leer y escribir
--------------------------------------------------------------------------------
                                   |      Freq.    Percent      Valid       Cum.
-----------------------------------+--------------------------------------------
Valid   1 si, sabe leer y escribir |   2.41e+07      84.31      88.75      88.75
        2 no, sabe leer y escribir |    3052721      10.68      11.25     100.00
        Total                      |   2.71e+07      95.00     100.00           
Missing .                          |    1429609       5.00                      
Total                              |   2.86e+07     100.00                      
--------------------------------------------------------------------------------
*/
recode c5_p12 (2 = 1) (1 = 0), gen(No_leer_escribir)

fre c5_p15
/*
c5_p15 -- p3a+: la institución educativa al que asiste está ubicada:
------------------------------------------------------------------------------
                                 |      Freq.    Percent      Valid       Cum.
---------------------------------+--------------------------------------------
Valid   1 aquí, en este distrito |    6864299      24.02      74.82      74.82
        2 en otro distrito       |    2310176       8.08      25.18     100.00
        Total                    |    9174475      32.11     100.00           
Missing .                        |   1.94e+07      67.89                      
Total                            |   2.86e+07     100.00                      
------------------------------------------------------------------------------
*/
recode c5_p15 (2 = 1) (1 = 0), gen(Asiste_IE_otro_distrito)

fre c5_p13_niv
/*
c5_p13_niv -- p3a+: Último nivel de estudio que aprobó
---------------------------------------------------------------------------------------------
                                                |      Freq.    Percent      Valid       Cum.
------------------------------------------------+--------------------------------------------
Valid   1  sin nivel                            |    1752655       6.13       6.46       6.46
        2  inicial                              |    1470742       5.15       5.42      11.87
        3  primaria                             |    7245703      25.36      26.69      38.57
        4  secundaria                           |    9588525      33.56      35.32      73.89
        5  básica especial                      |      45729       0.16       0.17      74.06
        6  superior no universitaria incompleta |    1114858       3.90       4.11      78.17
        7  superior no universitaria completa   |    1838660       6.43       6.77      84.94
        8  superior universitaria incompleta    |    1384782       4.85       5.10      90.04
        9  superior universitaria completa      |    2375799       8.31       8.75      98.79
        10 maestría / doctorado                 |     327275       1.15       1.21     100.00
        Total                                   |   2.71e+07      95.00     100.00           
Missing .                                       |    1429609       5.00                      
Total                                           |   2.86e+07     100.00                      
---------------------------------------------------------------------------------------------
*/
recode c5_p13_niv (4 6 7 8 9 10 = 1) (1 2 3 5 = 0), gen(Nive_secundaria_más_17)


* Porcentaje personas de 15 a más años con nivel alcanzado mínimo de secundario

* Porcentaje Personas que no saben leer ni escribir 
preserve
	tab c5_p4_1 c5_p12, miss // Agregar un rango de edad 
	drop if c5_p4_1==.

	collapse (mean) No_leer_escribir [iw=id_pob_imp_f], by(ubigeo)
	
	save "$Output\No saben leer ni escribir.dta", replace
restore

* Porcentaje población que asiste una IE en otro distrito
preserve
	// Delimitar a la población en un rango de edad y/o caracteristica
	drop if c5_p15==.

	collapse (mean) Asiste_IE_otro_distrito [iw=id_pob_imp_f], by(ubigeo)
	
	save "$Output\Asiste una IE en otro distrito.dta", replace
restore

* Porcentaje personas de 17 a más años con nivel alcanzado mínimo de secundario
preserve
	tab c5_p4_1 c5_p13_niv, miss // Agregar un rango de edad 
	drop if c5_p13_niv==.
	drop if c5_p4_1>=17
	collapse (mean) Nive_secundaria_más_17 [iw=id_pob_imp_f], by(ubigeo)
	
	save "$Output\Secundaria alcanzada más 17.dta", replace
restore

* Años promedios de escolaridad de 3 a 17 años
*preserve
*restore

* Porcentaje de Hogar con niños que no estudian (de 6 a 12 años)
*preserve
*restore

********************************************************************************
********************************************************************************

use "$Output\No saben leer ni escribir.dta", replace

merge 1:1 ubigeo using "$Output\Asiste una IE en otro distrito.dta", nogen
merge 1:1 ubigeo using "$Output\Secundaria alcanzada más 17.dta", nogen

save "$Output\03. Servicios de educación básica.dta", replace





