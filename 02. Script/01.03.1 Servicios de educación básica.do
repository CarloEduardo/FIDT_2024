clear all
set more off

********************************************************************************
* Tema: Servicios de educación básica (Parte 1)
* Elaboracion: Carlos Torres
********************************************************************************

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path       = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024"
global Ubigeo     = "$Path\01. Input\00. Dataset\00. Ubigeo"
*global Censo_2017 = "$Path\01. Input\00. Dataset\01. Censo 2017"
global Censo_2017 = "E:\01. DataBase\FIDT\01. Censo 2017" // Debido al peso, los archivos del Censo no se subieron 
global Output     = "$Path\01. Input\03. Servicios de educación básica"

********************************************************************************
********************************************************************************
* V06 ==> Porcentaje Personas que no saben leer ni escribir 
* Información extraida del OFICIO N° 000319-2024-INEI/JEF
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Censo_2017\INFORMACION MEF REG. 7922.xlsx", sheet("ANALF_DIST") clear cellrange(B8:L1898)

rename B ubigeo	
rename C Distrito
rename D Total
rename E Población_alfabeta
rename F Población_analfabeta
rename G Total_urbano
rename H Población_alfabeta_urbano
rename I Población_analfabeta_urbano
rename J Total_rural
rename K Población_alfabeta_rural
rename L Población_analfabeta_rural

gen P_Analfabeta = Población_analfabeta / Total

keep ubigeo P_Analfabeta

save "$Output\Analfabeta.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje población que asiste una IE en otro distrito

* Porcentaje personas de 15 a más años con nivel alcanzado mínimo de secundario

* Años promedios de escolaridad de 3 a 17 años

* Porcentaje de Hogar con niños que no estudian (de 6 a 12 años)
********************************************************************************
********************************************************************************

use "$Censo_2017\cpv2017_pob.dta", clear

gen ubigeo = ccdd + ccpp + ccdi

* Filtering data
*'''''''''''''''

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
recode c5_p13_niv (4 6 7 8 9 10 = 1) (1 2 3 5 = 0), gen(Nivel_secundaria_más_17)

** Years of Schooling
br c5_p13_niv c5_p13_gra c5_p13_anio_pri c5_p13_anio_sec
egen    tmp_years=rowmax(c5_p13_gra c5_p13_anio_pri c5_p13_anio_sec)
gen     Schooling= 0             if (c5_p13_niv<= 2)                // Sin nivel e Inicial
replace Schooling=     tmp_years if (c5_p13_niv== 3 & tmp_years<=6) // primaria
replace Schooling= 6 + tmp_years if (c5_p13_niv== 4 & tmp_years<=5) // secundaria
replace Schooling=11 + 1.5       if (c5_p13_niv== 6) // superior no universitaria incompleta
replace Schooling=11 + 3         if (c5_p13_niv== 7) // superior no universitaria completa
replace Schooling=11 + 2.5       if (c5_p13_niv== 8) // superior universitaria incompleta 
replace Schooling=11 + 5         if (c5_p13_niv== 9) // superior universitaria completa
replace Schooling=16 + 2         if (c5_p13_niv==10) // maestría / doctorado

fre c5_p14
/*
c5_p14 -- p3a+:  actualmente - asiste a algún colegio, instituto o universidad
-----------------------------------------------------------------------------------------------
                                                  |      Freq.    Percent      Valid       Cum.
--------------------------------------------------+--------------------------------------------
Valid   1 si, asiste a algún colegió, instituto o |    9174475      32.11      33.80      33.80
          universidad                             |                                            
        2 no, asiste a algún colegió, instituto o |   1.80e+07      62.89      66.20     100.00
          universidad                             |                                            
        Total                                     |   2.71e+07      95.00     100.00           
Missing .                                         |    1429609       5.00                      
Total                                             |   2.86e+07     100.00                      
-----------------------------------------------------------------------------------------------
*/
recode c5_p14 (2 = 1) (1 = 0), gen(No_estudian_6_17)

* Porcentaje población que asiste una IE en otro distrito
preserve
	* (2  inicial) (3  primaria) (4  secundaria) (5  básica especial)
	keep if c5_p13_niv==2 | c5_p13_niv==3 | c5_p13_niv==4 | c5_p13_niv==5 // c5_p13_niv -- p3a+: Último nivel de estudio que aprobó 
	keep if c5_p14==1 // p3a+:  actualmente - asiste a algún colegio, instituto o universidad
	drop if c5_p15==. // p3a+: la institución educativa al que asiste está ubicada:

	collapse (mean) Asiste_IE_otro_distrito [iw=factor_pond], by(ubigeo)
	
	save "$Output\Asiste a una IE en otro distrito.dta", replace
restore

* Porcentaje personas de 17 a más años que no culminaron el nivel secundario
preserve
	keep if c5_p4_1>=17 // p: edad en años
	
	collapse (mean) Nivel_secundaria_más_17 [iw=factor_pond], by(ubigeo)	
	
	save "$Output\Nivel secundaria alcanzada más 17 años.dta", replace
restore

* Años promedios de escolaridad de 3 a 17 años
preserve
	keep if c5_p4_1>=17 // p: edad en años
	
	collapse (mean) Schooling [iw=factor_pond], by(ubigeo)	
	
	save "$Output\Años promedios de escolaridad.dta", replace	
restore

* Porcentaje de Hogar con personas de 6 a 17 años que no estudian 
preserve
	keep if c5_p4_1 >= 6 & c5_p4_1 <= 17

	unique id_hog_imp_f // 3,787,296
	
	keep ubigeo id_hog_imp_f No_estudian_6_17
	duplicates drop
	bys ubigeo id_hog_imp_f: gen dupli=_N
	drop if dupli==2 & No_estudian_6_17==0
	
	unique id_hog_imp_f // 3,787,296
	
	collapse (mean) No_estudian_6_17, by(ubigeo)	
	
	save "$Output\Personas de 6 a 17 años que no estudian.dta", replace		
restore

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************

* Merging datasets
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Ubigeo\UBIGEO 2022.dta", clear
merge 1:1 ubigeo using "$Output\Analfabeta.dta", nogen
merge 1:1 ubigeo using "$Output\Asiste a una IE en otro distrito.dta", nogen
merge 1:1 ubigeo using "$Output\Nivel secundaria alcanzada más 17 años.dta", nogen
merge 1:1 ubigeo using "$Output\Años promedios de escolaridad.dta", nogen
merge 1:1 ubigeo using "$Output\Personas de 6 a 17 años que no estudian.dta", nogen

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\03.1 Servicios de educación básica_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\03.1 Servicios de educación básica.dta", replace

