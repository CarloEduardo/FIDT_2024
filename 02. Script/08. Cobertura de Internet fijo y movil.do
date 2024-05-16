* Tema: 08. Telecomunicación rural
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path_1 = "E:\01. DataBase\1. INEI\5 CVP 2017"
global Path_2 = "E:\01. DataBase\4. MTC\01. DGPRC"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\08. Telecomunicación rural"

********************************************************************************
********************************************************************************
* Porcentaje de hogares rurales sin acceso a teléfono celular
* Porcentaje de hogares rurales sin acceso a teléfono fijo
* Porcentaje de hogares rurales sin acceso a internet
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Path_1\cpv2017_hog.dta", clear

gen ubigeo = ccdd + ccpp + ccdi

* Filtering data
*'''''''''''''''

fre thogar // thogar -- p: total de hogares 
br   if thogar==99
drop if thogar==99


fre c3_p2_10
/*
c3_p2_10 -- H: Su hogar tiene: Tel�fono celular
-------------------------------------------------------------------------------------------------
                                                    |      Freq.    Percent      Valid       Cum.
----------------------------------------------------+--------------------------------------------
Valid   1                Si, tiene tel�fono celular |    6912745      64.87      83.77      83.77
        2                No, tiene tel�fono celular |    1339539      12.57      16.23     100.00
        Total                                       |    8252284      77.44     100.00           
Missing .                                           |    2403949      22.56                      
Total                                               |   1.07e+07     100.00                      
-------------------------------------------------------------------------------------------------
*/
recode c3_p2_10 (2 = 1) (1 = 0), gen(Sin_teléfono_celular)

fre c3_p2_11
/*
c3_p2_11 -- H: Su hogar tiene: Tel�fono fijo
----------------------------------------------------------------------------------------------
                                                 |      Freq.    Percent      Valid       Cum.
-------------------------------------------------+--------------------------------------------
Valid   1                Si, tiene tel�fono fijo |    1805771      16.95      21.88      21.88
        2                No, tiene tel�fono fijo |    6446513      60.50      78.12     100.00
        Total                                    |    8252284      77.44     100.00           
Missing .                                        |    2403949      22.56                      
Total                                            |   1.07e+07     100.00                      
----------------------------------------------------------------------------------------------
*/
recode c3_p2_11 (2 = 1) (1 = 0), gen(Sin_teléfono_fijo)

fre c3_p2_13
/*
c3_p2_13 -- H: Su hogar tiene: Conexi�n a Internet
----------------------------------------------------------------------------------------------------
                                                       |      Freq.    Percent      Valid       Cum.
-------------------------------------------------------+--------------------------------------------
Valid   1                Si, tiene conexi�n a internet |    2314182      21.72      28.04      28.04
        2                No, tiene conexi�n a internet |    5938102      55.72      71.96     100.00
        Total                                          |    8252284      77.44     100.00           
Missing .                                              |    2403949      22.56                      
Total                                                  |   1.07e+07     100.00                      
----------------------------------------------------------------------------------------------------
*/
recode c3_p2_13 (2 = 1) (1 = 0), gen(Sin_conexión_internet)

drop if c3_p2_10==. & c3_p2_11==. & c3_p2_13==.

*svyset Conglomerado [pw=id_viv_imp_f], strata(Estrato)vce(linearized)singleunit(centered)
*collapse (mean) f_agua f_desag [iw=id_viv_imp_f], by(ubigeo encarea)

collapse (mean) Sin_teléfono_celular Sin_teléfono_fijo Sin_conexión_internet [iw=id_hog_imp_f], by(ubigeo encarea)

* encarea 1 = urbano
* encarea 2 = rural

reshape wide Sin_teléfono_celular Sin_teléfono_fijo Sin_conexión_internet, i(ubigeo) j(encarea)

rename (Sin_teléfono_celular1  Sin_teléfono_celular2)  (Sin_teléfono_celular_urbano  Sin_teléfono_celular_rural)
rename (Sin_teléfono_fijo1     Sin_teléfono_fijo2)     (Sin_teléfono_fijo_urbano     Sin_teléfono_fijo_rural)
rename (Sin_conexión_internet1 Sin_conexión_internet2) (Sin_conexión_internet_urbano Sin_conexión_internet_rural)

foreach var of varlist Sin_teléfono_celular_urbano Sin_teléfono_fijo_urbano Sin_conexión_internet_urbano Sin_teléfono_celular_rural Sin_teléfono_fijo_rural Sin_conexión_internet_rural {
	replace `var' = 0 if `var' == .
}

save "$Output\Sin acceso a teléfono celular, fijo o internet.dta", replace

********************************************************************************
********************************************************************************
* Cobertura de internet movil
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path_2\1.2. Cobertura Internet Fijo.xlsx", sheet("Cobertura por Tecnologia") firstrow clear cellrange(B4:W108119)

gen ubigeo =  substr(UBIGEO,1,6)

global vars = "xDSL DOCSIS FTTX VSAT LTE WIMAX Microondas WiFi RadioEnlace OtraTecnología COBERTURAsinSatelital2"

collapse (sum) $vars, by(ubigeo CLASIFICACIONDEAREA)

gen Cobertura_inter_fijo = xDSL + DOCSIS + FTTX + LTE + WIMAX + Microondas + WiFi + RadioEnlace + OtraTecnología
gen Cobertura_inter_fijo_dummy = cond(Cobertura_inter_fijo>0,1,0)

encode CLASIFICACIONDEAREA, generate(area_inei)

fre area_inei
/*
area_inei -- CLASIFICACION DE AREA
--------------------------------------------------------------
                 |      Freq.    Percent      Valid       Cum.
-----------------+--------------------------------------------
Valid   1 RURAL  |       1830      49.18      49.18      49.18
        2 URBANO |       1891      50.82      50.82     100.00
        Total    |       3721     100.00     100.00           
--------------------------------------------------------------
*/

keep ubigeo area_inei Cobertura_inter_fijo Cobertura_inter_fijo_dummy
reshape wide Cobertura_inter_fijo Cobertura_inter_fijo_dummy, i(ubigeo) j(area_inei)

rename (Cobertura_inter_fijo1 Cobertura_inter_fijo2) (Cobertura_inter_fijo_rur Cobertura_inter_fijo_urb)
rename (Cobertura_inter_fijo_dummy1 Cobertura_inter_fijo_dummy2) (Cobertura_inter_fijo_dummy_rur Cobertura_inter_fijo_dummy_urb)

foreach var of varlist Cobertura_inter_fijo_rur Cobertura_inter_fijo_dummy_rur Cobertura_inter_fijo_urb Cobertura_inter_fijo_dummy_urb {
	replace `var' = 0 if `var' == .
}

save "$Output\Cobertura de internet fijo.dta", replace

********************************************************************************
********************************************************************************
* Cobertura de internet movil
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Path_2\1.1. Cobertura Servicio Móvil.xlsx", sheet("Cobertura CCPP") firstrow clear cellrange(B9:CL108124)

gen ubigeo =  substr(UBIGEO,1,6)

* TELEFONÍA MÓVIL
rename (G Q R Total) (telf_movil_Vitel_2G telf_movil_Vitel_3G telf_movil_Vitel_4G telf_movil_Vitel_TOTAL) 
rename (T U V W X TOTAL) (telf_movil_Entel_2G telf_movil_Entel_3G telf_movil_Entel_4G telf_movil_Entel_45G telf_movil_Entel_5G telf_movil_Entel_TOTAL)  
rename (Z AA AB AC AD) (telf_movil_Claro_2G telf_movil_Claro_3G telf_movil_Claro_4G telf_movil_Claro_45G telf_movil_Claro_TOTAL)  
rename (AE AF AG AH AI) (telf_movil_Telefonica_2G telf_movil_Telefonica_3G telf_movil_Telefonica_4G telf_movil_Telefonica_45G telf_movil_Telefonica_TOTAL)  
rename (TOTALTM) (telf_movil_TOTAL)

* INTERNET MÓVIL
rename (AK AL AM AN) (inter_movil_Vitel_2G inter_movil_Vitel_3G inter_movil_Vitel_4G inter_movil_Vitel_TOTAL)
rename (AO AP AQ AR AS AT) (inter_movil_Entel_2G inter_movil_Entel_3G inter_movil_Entel_4G inter_movil_Entel_45G inter_movil_Entel_5G inter_movil_Entel_TOTAL)
rename (AU AV AW AX AY AZ) (inter_movil_Claro_2G inter_movil_Claro_3G inter_movil_Claro_4G inter_movil_Claro_45G inter_movil_Claro_5G inter_movil_Claro_TOTAL)
rename (BA BB BC BD BE) (inter_movil_Telefonica_2G inter_movil_Telefonica_3G inter_movil_Telefonica_4G inter_movil_Telefonica_45G inter_movil_Telefonica_TOTAL)
rename (TOTALIM) (inter_movil_TOTAL)

* SERVICIOS MÓVILES POR OPERADOR
rename (BG BH BI BJ) (serv_movi_oper_Vitel_2G serv_movi_oper_Vitel_3G serv_movi_oper_Vitel_4G serv_movi_oper_Vitel_TOTAL)
rename (BK BL BM BN BO BP) (serv_movi_oper_Entel_2G serv_movi_oper_Entel_3G serv_movi_oper_Entel_4G serv_movi_oper_Entel_45G serv_movi_oper_Entel_5G serv_movi_oper_Entel_TOTAL) 
rename (BQ BR BS BT BU BV) (serv_movi_oper_Claro_2G serv_movi_oper_Claro_3G serv_movi_oper_Claro_4G serv_movi_oper_Claro_45G serv_movi_oper_Claro_5G serv_movi_oper_Claro_TOTAL) 
rename (BW BX BY BZ CA) (serv_movi_oper_Telefonica_2G serv_movi_oper_Telefonica_3G serv_movi_oper_Telefonica_4G serv_movi_oper_Telefonica_45G serv_movi_oper_Telefonica_TOTAL) 

* INTERNET MÓVIL
rename (CB CC CD CE CF) (inter_movil_3G inter_movil_4G inter_movil_45G inter_movil_5G inter_movil_TOTAL_TOTAL)

* SERVICIOS MÓVILES
rename (CG CH CI CJ CK CL) (serv_movi_oper_2G serv_movi_oper_3G serv_movi_oper_4G serv_movi_oper_45G serv_movi_oper_5G serv_movi_oper_TOTAL_TOTAL)

global vars = "telf_movil_Vitel_2G telf_movil_Vitel_3G telf_movil_Vitel_4G telf_movil_Vitel_TOTAL telf_movil_Entel_2G telf_movil_Entel_3G telf_movil_Entel_4G telf_movil_Entel_45G telf_movil_Entel_5G telf_movil_Entel_TOTAL telf_movil_Claro_2G telf_movil_Claro_3G telf_movil_Claro_4G telf_movil_Claro_45G telf_movil_Claro_TOTAL telf_movil_Telefonica_2G telf_movil_Telefonica_3G telf_movil_Telefonica_4G telf_movil_Telefonica_45G telf_movil_Telefonica_TOTAL telf_movil_TOTAL inter_movil_Vitel_2G inter_movil_Vitel_3G inter_movil_Vitel_4G inter_movil_Vitel_TOTAL inter_movil_Entel_2G inter_movil_Entel_3G inter_movil_Entel_4G inter_movil_Entel_45G inter_movil_Entel_5G inter_movil_Entel_TOTAL inter_movil_Claro_2G inter_movil_Claro_3G inter_movil_Claro_4G inter_movil_Claro_45G inter_movil_Claro_5G inter_movil_Claro_TOTAL inter_movil_Telefonica_2G inter_movil_Telefonica_3G inter_movil_Telefonica_4G inter_movil_Telefonica_45G inter_movil_Telefonica_TOTAL inter_movil_TOTAL serv_movi_oper_Vitel_2G serv_movi_oper_Vitel_3G serv_movi_oper_Vitel_4G serv_movi_oper_Vitel_TOTAL serv_movi_oper_Entel_2G serv_movi_oper_Entel_3G serv_movi_oper_Entel_4G serv_movi_oper_Entel_45G serv_movi_oper_Entel_5G serv_movi_oper_Entel_TOTAL serv_movi_oper_Claro_2G serv_movi_oper_Claro_3G serv_movi_oper_Claro_4G serv_movi_oper_Claro_45G serv_movi_oper_Claro_5G serv_movi_oper_Claro_TOTAL serv_movi_oper_Telefonica_2G serv_movi_oper_Telefonica_3G serv_movi_oper_Telefonica_4G serv_movi_oper_Telefonica_45G serv_movi_oper_Telefonica_TOTAL inter_movil_3G inter_movil_4G inter_movil_45G inter_movil_5G inter_movil_TOTAL_TOTAL serv_movi_oper_2G serv_movi_oper_3G serv_movi_oper_4G serv_movi_oper_45G serv_movi_oper_5G serv_movi_oper_TOTAL_TOTAL"

collapse (sum) $vars, by(ubigeo CLASIFICACIONDEAREA)

gen Cobertura_inter_movil = inter_movil_Vitel_3G         + inter_movil_Vitel_4G         + /// 
							inter_movil_Entel_3G         + inter_movil_Entel_4G         + inter_movil_Entel_45G         + inter_movil_Entel_5G + /// 
							inter_movil_Claro_3G         + inter_movil_Claro_4G         + inter_movil_Claro_45G         + inter_movil_Claro_5G + ///  
							inter_movil_Telefonica_3G    + inter_movil_Telefonica_4G    + inter_movil_Telefonica_45G
gen Cobertura_inter_movil_dummy = cond(Cobertura_inter_movil>0,1,0)

encode CLASIFICACIONDEAREA, generate(area_inei)

fre area_inei
/*
area_inei -- CLASIFICACION DE AREA
--------------------------------------------------------------
                 |      Freq.    Percent      Valid       Cum.
-----------------+--------------------------------------------
Valid   1 RURAL  |       1830      49.18      49.18      49.18
        2 URBANO |       1891      50.82      50.82     100.00
        Total    |       3721     100.00     100.00           
--------------------------------------------------------------
*/

keep ubigeo area_inei Cobertura_inter_movil Cobertura_inter_movil_dummy
reshape wide Cobertura_inter_movil Cobertura_inter_movil_dummy, i(ubigeo) j(area_inei)

rename (Cobertura_inter_movil1       Cobertura_inter_movil2)       (Cobertura_inter_movil_rur       Cobertura_inter_movil_urb)
rename (Cobertura_inter_movil_dummy1 Cobertura_inter_movil_dummy2) (Cobertura_inter_movil_dummy_rur Cobertura_inter_movil_dummy_urb)

foreach var of varlist Cobertura_inter_movil_rur Cobertura_inter_movil_dummy_rur Cobertura_inter_movil_urb Cobertura_inter_movil_dummy_urb {
	replace `var' = 0 if `var' == .
}

save "$Output\Cobertura de internet movil.dta", replace

********************************************************************************
********************************************************************************

use "$Output\Sin acceso a teléfono celular, fijo o internet.dta", replace

merge 1:1 ubigeo using "$Output\Cobertura de internet fijo.dta", nogen
merge 1:1 ubigeo using "$Output\Cobertura de internet movil.dta", nogen

save "$Output\08. Telecomunicación rural.dta", replace
