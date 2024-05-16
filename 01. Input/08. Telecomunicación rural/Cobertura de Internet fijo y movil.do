* Tema: 08. Telecomunicación rural
* Elaboracion: Carlos Torres
* Link:  
********************************************************************************

clear all
set more off

* Work route
********************************************************************************
global Path = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT\01. Input\08. Telecomunicación rural"

********************************************************************************
********************************************************************************
*                                                                              *
*                          Cobertura de Internet fijo                          *
*                                                                              *
********************************************************************************
********************************************************************************

* Importing database
********************************************************************************

import excel "$Path\Cobertura_MTC.xlsx", sheet("BD") clear firstrow
	
gen ubigeo = substr(UbigeodelCentroPoblado,1,6)	

global vars = "telf_movil_Vitel_2G telf_movil_Vitel_3G telf_movil_Vitel_4G telf_movil_TOTAL_Vitel telf_movil_Entel_2G telf_movil_Entel_3G telf_movil_Entel_4G telf_movil_Entel_45G telf_movil_Entel_5G telf_movil_TOTAL_Entel telf_movil_Claro_2G telf_movil_Claro_3G telf_movil_Claro_4G telf_movil_Claro_45G telf_movil_TOTAL_Claro telf_movil_Telefonica_2G telf_movil_Telefonica_3G telf_movil_Telefonica_4G telf_movil_Telefonica_45G telf_movil_TOTAL_Telefonica telf_movil_TOTAL inter_movil_Vitel_2G inter_movil_Vitel_3G inter_movil_Vitel_4G inter_movil_TOTAL_Vitel inter_movil_Entel_2G inter_movil_Entel_3G inter_movil_Entel_4G inter_movil_Entel_45G inter_movil_Entel_5G inter_movil_TOTAL_Entel inter_movil_Claro_2G inter_movil_Claro_3G inter_movil_Claro_4G inter_movil_Claro_45G inter_movil_TOTAL_Claro inter_movil_Telefonica_2G inter_movil_Telefonica_3G inter_movil_Telefonica_4G inter_movil_Telefonica_45G inter_movil_TOTAL_Telefonica inter_movil_TOTAL serv_movi_oper_Vitel_2G serv_movi_oper_Vitel_3G serv_movi_oper_Vitel_4G serv_movi_oper_TOTAL_Vitel serv_movi_oper_Entel_2G serv_movi_oper_Entel_3G serv_movi_oper_Entel_4G serv_movi_oper_Entel_45G serv_movi_oper_Entel_5G serv_movi_oper_TOTAL_Entel serv_movi_oper_Claro_2G serv_movi_oper_Claro_3G serv_movi_oper_Claro_4G serv_movi_oper_Claro_45G serv_movi_oper_TOTAL_Claro serv_movi_oper_Telefonica_2G serv_movi_oper_Telefonica_3G serv_movi_oper_Telefonica_4G serv_movi_oper_Telefonica_45G serv_movi_oper_TOTAL_Telefonica serv_movi_oper_2G serv_movi_oper_3G serv_movi_oper_4G serv_movi_oper_45G serv_movi_oper_TOTAL INTERNETMÓVIL xDSL DOCSIS FTTX LTE Microondas WiFi OtraTecnología ENLACERADIOPUNTOPUNTO PDH WIMAX TOTALsinconsiderartecnologí"

collapse (sum) $vars, by(ubigeo areainei)

gen cobertura_internet_fijo = xDSL + DOCSIS + FTTX + LTE + Microondas + WiFi + OtraTecnología + ENLACERADIOPUNTOPUNTO + PDH + WIMAX
gen cobertura_internet_fijo_dummy = cond(cobertura_internet_fijo>0,1,0)

gen cobertura_internet_movil = telf_movil_Vitel_3G          + telf_movil_Vitel_4G          + /// 
							   telf_movil_Entel_3G          + telf_movil_Entel_4G          + telf_movil_Entel_45G          + telf_movil_Entel_5G + /// 
							   telf_movil_Claro_3G          + telf_movil_Claro_4G          + telf_movil_Claro_45G          + /// 
							   telf_movil_Telefonica_3G     + telf_movil_Telefonica_4G     + telf_movil_Telefonica_45G     + /// 
							   inter_movil_Vitel_3G         + inter_movil_Vitel_4G         + /// 
							   inter_movil_Entel_3G         + inter_movil_Entel_4G         + inter_movil_Entel_45G         + inter_movil_Entel_5G + /// 
							   inter_movil_Claro_3G         + inter_movil_Claro_4G         + inter_movil_Claro_45G         + ///  
							   inter_movil_Telefonica_3G    + inter_movil_Telefonica_4G    + inter_movil_Telefonica_45G    + /// 
							   serv_movi_oper_Vitel_3G      + serv_movi_oper_Vitel_4G      + /// 
							   serv_movi_oper_Entel_3G      + serv_movi_oper_Entel_4G      + serv_movi_oper_Entel_45G      + serv_movi_oper_Entel_5G + /// 
							   serv_movi_oper_Claro_3G      + serv_movi_oper_Claro_4G      + serv_movi_oper_Claro_45G      + ///
							   serv_movi_oper_Telefonica_3G + serv_movi_oper_Telefonica_4G + serv_movi_oper_Telefonica_45G
gen cobertura_internet_movil_dummy = cond(cobertura_internet_movil>0,1,0)

encode areainei, generate(area_inei)

fre area_inei
/*
area_inei -- area inei
--------------------------------------------------------------
                 |      Freq.    Percent      Valid       Cum.
-----------------+--------------------------------------------
Valid   1 NA     |        248       6.30       6.30       6.30
        2 RURAL  |       1814      46.09      46.09      52.39
        3 URBANO |       1874      47.61      47.61     100.00
        Total    |       3936     100.00     100.00           
--------------------------------------------------------------
*/

keep ubigeo area_inei cobertura_internet_fijo cobertura_internet_fijo_dummy cobertura_internet_movil cobertura_internet_movil_dummy
reshape wide cobertura_internet_fijo cobertura_internet_fijo_dummy cobertura_internet_movil cobertura_internet_movil_dummy, i(ubigeo) j(area_inei)

rename (cobertura_internet_fijo1  cobertura_internet_fijo_dummy1)  (cobertura_internet_fijo_NA  cobertura_internet_fijodummy_NA) 
rename (cobertura_internet_fijo2  cobertura_internet_fijo_dummy2)  (cobertura_internet_fijo_RU  cobertura_internet_fijodummy_RU) 
rename (cobertura_internet_fijo3  cobertura_internet_fijo_dummy3)  (cobertura_internet_fijo_UR  cobertura_internet_fijodummy_UR)
rename (cobertura_internet_movil1 cobertura_internet_movil_dummy1) (cobertura_internet_movil_NA cobertura_internet_movildummy_NA) 
rename (cobertura_internet_movil2 cobertura_internet_movil_dummy2) (cobertura_internet_movil_RU cobertura_internet_movildummy_RU) 
rename (cobertura_internet_movil3 cobertura_internet_movil_dummy3) (cobertura_internet_movil_UR cobertura_internet_movildummy_UR)

foreach var of varlist cobertura_internet_fijo_NA cobertura_internet_fijodummy_NA cobertura_internet_movil_NA cobertura_internet_movildummy_NA cobertura_internet_fijo_RU cobertura_internet_fijodummy_RU cobertura_internet_movil_RU cobertura_internet_movildummy_RU cobertura_internet_fijo_UR cobertura_internet_fijodummy_UR cobertura_internet_movil_UR cobertura_internet_movildummy_UR {
	replace `var' = 0 if `var' == .
}

save "$Path\Cobertura de Internet fijo y movil.dta", replace
	
