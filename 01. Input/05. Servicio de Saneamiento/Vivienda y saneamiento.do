* Tema: Vivienda y saneamiento
* Elaboracion: Carlos Torres
* Link: 
********************************************************************************

clear all
set more off

* Work route
********************************************************************************
global Path   = "E:\01. DataBase\1. INEI\5 CVP 2017"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT\01. Input\05 Servicio de Saneamiento"

* Importing database
********************************************************************************
use "$Path\cpv2017_viv.dta", clear

* c2_p1 -- v: tipo de vivienda
br if thogar==99
fre c2_p1 if thogar==99
drop if thogar==99

* c2_p2 -- v: condici�n de ocupaci�n de la vivienda
br if c2_p2!=1
fre c2_p6 if c2_p2!=1
drop if c2_p2!=1

tab encarea area, miss
/*
   tipo de |
   �rea de |  v: tipo �rea censal
  encuesta |         1          2 |     Total
-----------+----------------------+----------
    urbano | 5,884,013          0 | 5,884,013 
     rural |   271,156  1,543,731 | 1,814,887 
-----------+----------------------+----------
     Total | 6,155,169  1,543,731 | 7,698,900 
*/

gen ubigeo = ccdd + ccpp + ccdi

********************************************************************************
********************************************************************************
*                                                                              *
*                   Porcentaje de viviendas sin agua seguro                    *
*              Porcentaje de viviendas sin desagüe de red pública              *
*                                                                              *
********************************************************************************
********************************************************************************		
			
fre c2_p6
/*
c2_p6 -- v: abastecimiento de agua en la vivienda
------------------------------------------------------------------------------------------------------
                                                         |      Freq.    Percent      Valid       Cum.
---------------------------------------------------------+--------------------------------------------
Valid   1  red p�blica dentro de la vivienda             |    5162821      67.06      67.06      67.06
        2  red p�blica fuera de la vivienda, pero dentro |     867340      11.27      11.27      78.32
           de la edificaci�n                             |                                            
        3  pil�n o pileta de uso p�blico                 |     362121       4.70       4.70      83.03
        4  cami�n - cisterna u otro similar              |     324832       4.22       4.22      87.25
        5  pozo (agua subterr�nea)                       |     562275       7.30       7.30      94.55
        6  manantial o puquio                            |      97712       1.27       1.27      95.82
        7  r�o, acequia, lago, laguna                    |     249571       3.24       3.24      99.06
        8  otro                                          |      26056       0.34       0.34      99.40
        10 vecino                                        |      46172       0.60       0.60     100.00
        Total                                            |    7698900     100.00     100.00           
------------------------------------------------------------------------------------------------------
*/

recode c2_p6 (1/3= 1 "Accede a agua potable por red pública o pilón") (4/10= 0 "Falta de acceso a agua por red pública o pilón")  (.=.), gen(f_agua)
lab var f_agua "Falta de acceso a agua potable por red pública o pilón"
					
fre c2_p10			
/*
c2_p10 -- v: servicio higi�nico que tiene la vivienda
----------------------------------------------------------------------------------------------------
                                                       |      Freq.    Percent      Valid       Cum.
-------------------------------------------------------+--------------------------------------------
Valid   1 red p�blica de desag�e dentro de la vivienda |    4513134      58.62      58.62      58.62
        2 red p�blica de desag�e fuera de la vivienda, |     617728       8.02       8.02      66.64
          pero dentro de la edificaci�n                |                                            
        3 pozo s�ptico, tanque s�ptico o biodigestor   |     308466       4.01       4.01      70.65
        4 letrina ( con tratamiento)                   |     431536       5.61       5.61      76.26
        5 pozo ciego o negro                           |    1309559      17.01      17.01      93.27
        6 r�o, acequia, canal o similar                |      53951       0.70       0.70      93.97
        7 campo abierto o al aire libre                |     406975       5.29       5.29      99.25
        8 otro                                         |      57551       0.75       0.75     100.00
        Total                                          |    7698900     100.00     100.00           
----------------------------------------------------------------------------------------------------
*/			
			
recode c2_p10 (1/2 = 1 "Acceso a red pública") (3/8= 0 "Falta de acceso a red pública") (.=.), gen(f_desag)
lab var f_desag "Falta de acceso a red pública de desagüe" 

*svyset Conglomerado [pw=id_viv_imp_f], strata(Estrato)vce(linearized)singleunit(centered)
*collapse (mean) f_agua f_desag [iw=id_viv_imp_f], by(ubigeo encarea)

collapse (mean) f_agua f_desag [iw=id_viv_imp_f], by(ubigeo encarea)

fre encarea
/*
encarea -- tipo de �rea de encuesta
--------------------------------------------------------------
                 |      Freq.    Percent      Valid       Cum.
-----------------+--------------------------------------------
Valid   1 urbano |        741      29.09      29.09      29.09
        2 rural  |       1806      70.91      70.91     100.00
        Total    |       2547     100.00     100.00           
--------------------------------------------------------------
*/

reshape wide f_agua f_desag, i(ubigeo) j(encarea)

rename (f_agua1 f_desag1) (f_agua_urbano f_desag_urbano) 
rename (f_agua2 f_desag2) (f_agua_rural  f_desag_rural) 

foreach var of varlist f_agua_urbano f_desag_urbano f_agua_rural f_desag_rural {
	replace `var' = 0 if `var' == .
}

save "$Output\Vivienda y saneamiento.dta", replace
