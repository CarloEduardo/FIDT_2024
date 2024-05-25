* Tema: Vivienda y saneamiento
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path   = "E:\01. DataBase\1. INEI\5 CVP 2017"
global Ubigeo = "E:\01. DataBase\1. INEI\4 SISCONCODE\01. UBIGEO 2022"
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
recode c2_p6 (4/10= 1 "Falta de acceso a agua por red pública o pilón") (1/3= 0 "Accede a agua potable por red pública o pilón") (.=.), gen(Sin_agua)
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

collapse (mean) Sin_agua Sin_desagüe, by(ubigeo)

save "$Output\Vivienda y saneamiento.dta", replace

*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Ubigeo\UBIGEO 2022.dta", clear
merge 1:1 ubigeo using "$Output\Vivienda y saneamiento.dta", keepusing(Sin_agua Sin_desagüe) nogen

* Imputation at the provincial level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
mdesc

gen id_reg_prov = substr(ubigeo,1,4)

bys id_reg_prov: egen Sin_agua_ip    = mean(Sin_agua)
bys id_reg_prov: egen Sin_desagüe_ip = mean(Sin_desagüe)

replace Sin_agua    = Sin_agua_ip    if Sin_agua==.
replace Sin_desagüe = Sin_desagüe_ip if Sin_desagüe==.

drop id_reg_prov Sin_agua_ip Sin_desagüe_ip

mdesc

/*
* Imputation at the regional level
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
mdesc

gen id_reg = substr(ubigeo,1,2)

bys id_reg: egen Sin_agua_ir    = mean(Sin_agua)
bys id_reg: egen Sin_desagüe_ir = mean(Sin_desagüe)

replace Sin_agua    = Sin_agua_ir    if Sin_agua==.
replace Sin_desagüe = Sin_desagüe_ir if Sin_desagüe==.

drop id_reg_prov Sin_agua_ir Sin_desagüe_ir

mdesc
*/

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\05. Vivienda y saneamiento_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\05. Vivienda y saneamiento.dta", replace
