* Tema: Vivienda y saneamiento
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path   = "E:\01. DataBase\1. INEI\5 CVP 2017"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\05. Servicio de Saneamiento"

********************************************************************************
********************************************************************************
* Porcentaje de viviendas sin agua seguro 
* Porcentaje de viviendas sin desagüe de red pública
********************************************************************************
********************************************************************************		

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
use "$Path\cpv2017_viv.dta", clear

gen ubigeo = ccdd + ccpp + ccdi

* c2_p1 -- v: tipo de vivienda
br if thogar==99
fre c2_p1 if thogar==99
drop if thogar==99

* c2_p2 -- v: condici�n de ocupaci�n de la vivienda
br if c2_p2!=1
fre c2_p6 if c2_p2!=1
drop if c2_p2!=1
		
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
recode c2_p6 (4/10= 1 "Falta de acceso a agua por red pública o pilón") (1/3= 0 "Accede a agua potable por red pública o pilón")   (.=.), gen(Sin_agua)
lab var Sin_agua "Falta de acceso a agua potable por red pública o pilón"
					
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
recode c2_p10 (3/8= 1 "Falta de acceso a red pública")  (1/2 = 0 "Acceso a red pública") (.=.), gen(Sin_desagüe)
lab var Sin_desagüe "Falta de acceso a red pública de desagüe" 

*svyset Conglomerado [pw=id_viv_imp_f], strata(Estrato)vce(linearized)singleunit(centered)
*collapse (mean) f_agua f_desag [iw=id_viv_imp_f], by(ubigeo encarea)

collapse (mean) Sin_agua Sin_desagüe [iw=id_viv_imp_f], by(ubigeo encarea)

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

reshape wide Sin_agua Sin_desagüe, i(ubigeo) j(encarea)

rename (Sin_agua1 Sin_desagüe1) (Sin_agua_urbano Sin_desagüe_urbano) 
rename (Sin_agua2 Sin_desagüe2) (Sin_agua_rural  Sin_desagüe_rural) 

foreach var of varlist Sin_agua_urbano Sin_desagüe_urbano Sin_agua_rural Sin_desagüe_rural {
	replace `var' = 0 if `var' == .
}

order ubigeo Sin_agua_urbano Sin_agua_rural Sin_desagüe_urbano Sin_desagüe_rural

save "$Output\05 Vivienda y saneamiento.dta", replace
