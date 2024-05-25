* Tema: 08. Telecomunicación rural
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path       = "E:\01. DataBase\FIDT"
global Ubigeo     = "$Path\00. Ubigeo"
global Censo_2017 = "$Path\01. Censo 2017"
global MTC        = "$Path\MTC"
global Output     = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\08. Telecomunicación rural"

********************************************************************************
********************************************************************************
* Porcentaje de hogares rurales sin acceso a teléfono celular
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Censo_2017\INFORMACION MEF REG. 7922.xlsx", sheet("CELULAR_DIST") clear cellrange(B9:L1899)

rename B ubigeo
rename C Distrito
rename D Total
rename E Con_teléfono_celular
rename F Sin_teléfono_celular
rename G Total_urbano
rename H Con_teléfono_celular_urbano
rename I Sin_teléfono_celular_urbano
rename J Total_rural
rename K Con_teléfono_celular_rural
rename L Sin_teléfono_celular_rural

replace Total_rural=""                if Total_rural=="-"
replace Sin_teléfono_celular_rural="" if Sin_teléfono_celular_rural=="-"

destring Total_rural, replace
destring Sin_teléfono_celular_rural, replace

gen P_Sin_teléfono_celular_rural = Sin_teléfono_celular_rural / Total_rural

keep ubigeo P_Sin_teléfono_celular_rural

save "$Output\Sin teléfono celular.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje de hogares rurales sin acceso a teléfono fijo
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Censo_2017\INFORMACION MEF REG. 7922.xlsx", sheet("TELEF_FIJO_DIST") clear cellrange(B9:L1899)

rename B ubigeo
rename C Distrito
rename D Total
rename E Con_teléfono_fijo
rename F Sin_teléfono_fijo
rename G Total_urbano
rename H Con_teléfono_fijo_urbano
rename I Sin_teléfono_fijo_urbano
rename J Total_rural
rename K Con_teléfono_fijo_rural
rename L Sin_teléfono_fijo_rural

replace Total_rural=""             if Total_rural=="-"
replace Sin_teléfono_fijo_rural="" if Sin_teléfono_fijo_rural=="-"

destring Total_rural, replace
destring Sin_teléfono_fijo_rural, replace

gen P_Sin_teléfono_fijo_rural = Sin_teléfono_fijo_rural / Total_rural

keep ubigeo P_Sin_teléfono_fijo_rural

save "$Output\Sin teléfono fijo.dta", replace

********************************************************************************
********************************************************************************
* Porcentaje de hogares rurales sin acceso a internet
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$Censo_2017\INFORMACION MEF REG. 7922.xlsx", sheet("INTERNET_DIST") clear cellrange(B9:L1899)

rename B ubigeo
rename C Distrito
rename D Total
rename E Con_conexión_internet
rename F Sin_conexión_internet
rename G Total_urbano
rename H Con_conexión_internet_urbano
rename I Sin_conexión_internet_urbano
rename J Total_rural
rename K Con_conexión_internet_rural
rename L Sin_conexión_internet_rural

replace Total_rural=""                if Total_rural=="-"
replace Sin_conexión_internet_rural="" if Sin_conexión_internet_rural=="-"

destring Total_rural, replace
destring Sin_conexión_internet_rural, replace

gen P_Sin_conexión_internet_rural = Sin_conexión_internet_rural / Total_rural

keep ubigeo P_Sin_conexión_internet_rural

save "$Output\Sin conexión a internet.dta", replace

********************************************************************************
********************************************************************************
* Cobertura de internet movil
********************************************************************************
********************************************************************************

* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

import excel "$MTC\1.1. Cobertura Servicio Móvil.xlsx", sheet("Cobertura CCPP") firstrow clear cellrange(B9:CL108124)

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

gen Cobertura_inter_movil_Vitel = inter_movil_Vitel_3G      + inter_movil_Vitel_4G
gen Cobertura_inter_movil_Entel = inter_movil_Entel_3G      + inter_movil_Entel_4G      + inter_movil_Entel_45G      + inter_movil_Entel_5G 
gen Cobertura_inter_movil_Claro = inter_movil_Claro_3G      + inter_movil_Claro_4G      + inter_movil_Claro_45G      + inter_movil_Claro_5G  
gen Cobertura_inter_movil_Telef = inter_movil_Telefonica_3G + inter_movil_Telefonica_4G + inter_movil_Telefonica_45G
												
gen Cobertura_inter_movil_dummy = cond(Cobertura_inter_movil>0,1,0)

gen Cobertura_inter_movil_Vitel_d = cond(Cobertura_inter_movil_Vitel>0,1,0)
gen Cobertura_inter_movil_Entel_d = cond(Cobertura_inter_movil_Entel>0,1,0)
gen Cobertura_inter_movil_Claro_d = cond(Cobertura_inter_movil_Claro>0,1,0)
gen Cobertura_inter_movil_Telef_d = cond(Cobertura_inter_movil_Telef>0,1,0)

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

keep ubigeo area_inei Cobertura_inter_movil Cobertura_inter_movil_dummy Cobertura_inter_movil_Vitel_d Cobertura_inter_movil_Entel_d Cobertura_inter_movil_Claro_d Cobertura_inter_movil_Telef_d

reshape wide Cobertura_inter_movil Cobertura_inter_movil_dummy Cobertura_inter_movil_Vitel_d Cobertura_inter_movil_Entel_d Cobertura_inter_movil_Claro_d Cobertura_inter_movil_Telef_d, i(ubigeo) j(area_inei)

rename (Cobertura_inter_movil1       Cobertura_inter_movil2)       (Cobertura_inter_movil_rur       Cobertura_inter_movil_urb)
rename (Cobertura_inter_movil_dummy1 Cobertura_inter_movil_dummy2) (Cobertura_inter_movil_dummy_rur Cobertura_inter_movil_dummy_urb)

rename (Cobertura_inter_movil_Vitel_d1 Cobertura_inter_movil_Vitel_d2) (Cobertura_inter_movil_Vitel_rur Cobertura_inter_movil_Vitel_urb)
rename (Cobertura_inter_movil_Entel_d1 Cobertura_inter_movil_Entel_d2) (Cobertura_inter_movil_Entel_rur Cobertura_inter_movil_Entel_urb)
rename (Cobertura_inter_movil_Claro_d1 Cobertura_inter_movil_Claro_d2) (Cobertura_inter_movil_Claro_rur Cobertura_inter_movil_Claro_urb)
rename (Cobertura_inter_movil_Telef_d1 Cobertura_inter_movil_Telef_d2) (Cobertura_inter_movil_Telef_rur Cobertura_inter_movil_Telef_urb)

gen Cobertura_inter_movil_rural = Cobertura_inter_movil_Vitel_rur + Cobertura_inter_movil_Entel_rur + Cobertura_inter_movil_Claro_rur + Cobertura_inter_movil_Telef_rur

save "$Output\Cobertura de internet movil.dta", replace

********************************************************************************
********************************************************************************

use "$Ubigeo\UBIGEO 2022.dta", clear

merge 1:1 ubigeo using "$Output\Sin teléfono celular.dta", nogen
merge 1:1 ubigeo using "$Output\Sin teléfono fijo.dta", nogen
merge 1:1 ubigeo using "$Output\Sin conexión a internet.dta", nogen
merge 1:1 ubigeo using "$Output\Cobertura de internet movil.dta", nogen keepusing(Cobertura_inter_movil_rural)

mdesc
/*
    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
         ubigeo |           0          1,891           0.00
         REGION |           0          1,891           0.00
      PROVINCIA |           0          1,891           0.00
       DISTRITO |           0          1,891           0.00
   P_Si~r_rural |          80          1,891           4.23
   P_Sin_cone~l |          70          1,891           3.70
   P_Si~o_rural |          69          1,891           3.65
   Cobertura_~l |          61          1,891           3.23
----------------+-----------------------------------------------
*/

* Save
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

save "$Output\08. Telecomunicación rural_all.dta", replace

drop REGION PROVINCIA DISTRITO

save "$Output\08. Telecomunicación rural.dta", replace
