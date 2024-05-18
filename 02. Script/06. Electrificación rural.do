* Tema: Electrificación rural
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path   = "E:\01. DataBase\1. INEI\5 CVP 2017"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\06. Electrificación rural"

********************************************************************************
********************************************************************************
* Porcentaje de viviendas rurales sin electricidad
* Porcentaje de población rural
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
fre c2_p11 if c2_p2!=1
drop if c2_p2!=1
			
fre c2_p11
/*
c2_p11 -- v: la vivienda tiene alumbrado el�ctrico
------------------------------------------------------------------------------------
                                       |      Freq.    Percent      Valid       Cum.
---------------------------------------+--------------------------------------------
Valid   1 si tiene alumbrado el�ctrico |    6750790      87.69      87.69      87.69
        2 no tiene alumbrado el�ctrico |     948110      12.31      12.31     100.00
        Total                          |    7698900     100.00     100.00           
------------------------------------------------------------------------------------
*/
recode c2_p11 (2 = 1 "Falta de acceso a electricidad")  (1 = 0 "Acceso a electricidad")  (.=.), gen(Sin_electricidad)
lab var Sin_electricidad "Falta de acceso a electricidad"

codebook t_c4_p1
/*
--------------------------------------------------------------------------------
t_c4_p1                                  v: total de la poblaci�n en la vivienda
--------------------------------------------------------------------------------

                  type:  numeric (byte)

                 range:  [1,53]                       units:  1
         unique values:  44                       missing .:  0/7,698,900

                  mean:   3.71148
              std. dev:   2.29736

           percentiles:        10%       25%       50%       75%       90%
                                 1         2         3         5         6
*/

collapse (mean) Sin_electricidad (sum) Población=t_c4_p1, by(ubigeo encarea)

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

reshape wide Sin_electricidad Población, i(ubigeo) j(encarea)

rename (Sin_electricidad1 Población1) (Sin_electricidad_urbano Población_urbano) 
rename (Sin_electricidad2 Población2) (Sin_electricidad_rural  Población_rural) 

foreach var of varlist Sin_electricidad_urbano Sin_electricidad_rural Población_urbano Población_rural {
	replace `var' = 0 if `var' == .
}

gen P_Población_rural = Población_rural/(Población_urbano+Población_rural)

order ubigeo Sin_electricidad_urbano Sin_electricidad_rural Población_urbano Población_rural P_Población_rural

save "$Output\06 Electrificación rural.dta", replace
