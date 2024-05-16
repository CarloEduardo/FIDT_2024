* Tema: Indicadores FIDT
* Elaboracion: Carlos Torres: 
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

global Path                    = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024"
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
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Salud\01 Salud Básica.dta", clear
merge 1:1 ubigeo using "$Desnutrición\02 Desnutrición infantil yo anemia infantil", nogen
merge 1:1 ubigeo using "$Educación\03 Servicios de educación básica", nogen
merge 1:1 ubigeo using "$Saneamiento\05 Vivienda y saneamiento", nogen
merge 1:1 ubigeo using "$Electrificación\06 Electrificación rural", nogen
merge 1:1 ubigeo using "$Telecomunicación\08 Telecomunicación rural", nogen
merge 1:1 ubigeo using "$Desarrollo_Productivo\09 Apoyo al desarrollo productivo.dta", nogen

save "$Input\Data_Warehouse.dta", replace