* Tema: Indicadores FIDT
* Elaboracion: Carlos Torres
* Link: 
********************************************************************************

clear all
set more off

* Work route
********************************************************************************

global Path                    = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT"
global Input                   = "$Path\01. Input"
global Salud                   = "$Input\01. Salud Básica"
global Desnutrición        	   = "$Input\02. Desnutrición infantil yo anemia infantil"
global Educación               = "$Input\03. Servicios de educación básica"
global Infraestructura         = "$Input\04. Infraestructura vial"
global Saneamiento             = "$Input\05. Servicio de Saneamiento"
global Electrificación         = "$Input\06. Electrificación rural"
global Telecomunicación        = "$Input\08. Telecomunicación rural"
global Desarrollo_Productivo   = "$Input\09. Apoyo al desarrollo productivo"
global Recursos_Presupuestales = "$Input\10. Recursos Presupuestales"
global Output                  = "$Path\03. Output"

* Data Warehouse
********************************************************************************

use "$Salud\Salud Básica.dta", clear

merge 1:1 ubigeo using "$Saneamiento\Vivienda y saneamiento.dta", keepusing(f_agua_rural f_desag_rural) nogen 
merge 1:1 ubigeo using "$Electrificación\Electrificación rural.dta", keepusing(f_elec_rural p_población_rural) nogen 
merge 1:1 ubigeo using "$Telecomunicación\Cobertura de Internet fijo y movil.dta", keepusing(cobertura_internet_fijo_RU cobertura_internet_fijodummy_RU cobertura_internet_movil_RU cobertura_internet_movildummy_RU) nogen 

d 