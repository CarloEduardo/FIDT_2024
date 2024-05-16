* Tema:Servicios de educación básica
* Elaboracion: Carlos Torres
* Link: 
********************************************************************************

clear all
set more off

* Work route
********************************************************************************
global Path   = "E:\01. DataBase\1. INEI\5 CVP 2017"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT\01. Input\03. Servicios de educación básica"

* Importing database
********************************************************************************

use "$Path\cpv2017_pob.dta", clear

* p: total de hogares
br if thogar=="99"
drop if thogar=="99"

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

d c5_p12
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

********************************************************************************
********************************************************************************
*                                                                              *
*              Porcentaje Personas que no saben leer ni escribir               * 
*           Porcentaje población que asiste una IE en otro distrito            *
* Porcentaje personas de 15 a más años con nivel alcanzado mínimo de secundario*
*                 Años promedios de escolaridad de 3 a 17años                  *
*        Porcentaje de Hogar con niños que no estudian (de 6 a 12 años)        *
*                                                                              *
********************************************************************************
********************************************************************************		


