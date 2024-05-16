* Tema: Vivienda y saneamiento
* Elaboracion: Carlos Torres
* Link: 
********************************************************************************

clear all
set more off

* Work route
********************************************************************************
global Path   = "E:\01. DataBase\1. INEI\5 CVP 2017"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT\01. Input\06. Electrificación rural"

* Importing database
********************************************************************************
use "$Path\cpv2017_viv.dta", clear

* c2_p1 -- v: tipo de vivienda
br if thogar==99
fre c2_p1 if thogar==99
drop if thogar==99

* c2_p2 -- v: condici�n de ocupaci�n de la vivienda
br if c2_p2!=1
fre c2_p11 if c2_p2!=1
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
*               Porcentaje de viviendas rurales sin electricidad               *
*                        Porcentaje de población rural                         *
*                                                                              *
********************************************************************************
********************************************************************************		
			
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

recode c2_p11 (1 = 1 "Acceso a electricidad") (2 = 0 "Falta de acceso a electricidad")  (.=.), gen(f_elec)
lab var f_elec "Falta de acceso a electricidad"

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

*svyset Conglomerado [pw=id_viv_imp_f], strata(Estrato)vce(linearized)singleunit(centered)
*collapse (mean) f_agua f_desag [iw=id_viv_imp_f], by(ubigeo encarea)

collapse (mean) f_elec (sum) t_c4_p1 [iw=id_viv_imp_f], by(ubigeo encarea)

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

reshape wide f_elec t_c4_p1, i(ubigeo) j(encarea)

rename (f_elec1 t_c4_p11) (f_elec_urbano t_c4_p1_urbano) 
rename (f_elec2 t_c4_p12) (f_elec_rural  t_c4_p1_rural) 

foreach var of varlist f_elec_urbano t_c4_p1_urbano f_elec_rural t_c4_p1_rural {
	replace `var' = 0 if `var' == .
}

gen p_población_rural = t_c4_p1_rural/(t_c4_p1_urbano+t_c4_p1_rural)

save "$Output\Electrificación rural.dta", replace
