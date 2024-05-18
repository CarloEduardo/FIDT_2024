* Tema: Servicios de educación básica
* Elaboracion: Carlos Torres
********************************************************************************

clear all
set more off

* Work route
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
global Path   = "E:\01. DataBase\1. INEI\5 CVP 2017"
global Output = "E:\03. Job\05. CONSULTORIAS\13. MEF\FIDT_2024\01. Input\03. Servicios de educación básica"

********************************************************************************
********************************************************************************
* Variable 06
* Porcentaje Personas que no saben leer ni escribir 
* Variable 07
* Porcentaje población que asiste una IE en otro distrito
* Variable 08
* Porcentaje personas de 15 a más años con nivel alcanzado mínimo de secundario
* Variable 09
* Años promedios de escolaridad de 3 a 17 años
* Variable 10
* Porcentaje de Hogar con niños que no estudian (de 6 a 12 años)
********************************************************************************
********************************************************************************

/*
Con esta variable pretendemos conocer el porcentaje de las personas que no saben leer ni escribir mayores a 6 años, lo cual puede deberse por la escasa oferta de infraestructura educativa.

Esta variable tiene como objetivo poder conocer el porcentaje de la población que asiste una IE en otro distrito (colegios), lo cual puede deberse por la escasa oferta de infraestructura educativa.

Con esta variable podremos conocer el porcentaje de personas de 17 años a más que no culminaron el nivel secundario, lo cual puede deberse por la escasa oferta de infraestructura educativa.

Con esta variable pretendemos conocer los años promedios de escolaridad de personas mayores a 17años, el cual de resultar bajo puede deberse por la escasa oferta de infraestructura educativa.

Esta variable tiene como objetivo poder conocer el porcentaje de hogar con personas que no estudian de 6 a 17 años, lo cual puede deberse por la escasa oferta de infraestructura educativa.
*/
	
* Importing database
*'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

use "$Path\cpv2017_pob.dta", clear

gen ubigeo = ccdd + ccpp + ccdi

* Filtering data
*'''''''''''''''

fre thogar // thogar -- p: total de hogares 
br   if thogar=="99"
drop if thogar=="99"

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
recode c5_p12 (2 = 1) (1 = 0), gen(No_leer_escribir)

fre c5_p15
/*
c5_p15 -- p3a+: la institución educativa al que asiste está ubicada:
------------------------------------------------------------------------------
                                 |      Freq.    Percent      Valid       Cum.
---------------------------------+--------------------------------------------
Valid   1 aquí, en este distrito |    6864299      24.02      74.82      74.82
        2 en otro distrito       |    2310176       8.08      25.18     100.00
        Total                    |    9174475      32.11     100.00           
Missing .                        |   1.94e+07      67.89                      
Total                            |   2.86e+07     100.00                      
------------------------------------------------------------------------------
*/
recode c5_p15 (2 = 1) (1 = 0), gen(Asiste_IE_otro_distrito)

fre c5_p13_niv
/*
c5_p13_niv -- p3a+: Último nivel de estudio que aprobó
---------------------------------------------------------------------------------------------
                                                |      Freq.    Percent      Valid       Cum.
------------------------------------------------+--------------------------------------------
Valid   1  sin nivel                            |    1752655       6.13       6.46       6.46
        2  inicial                              |    1470742       5.15       5.42      11.87
        3  primaria                             |    7245703      25.36      26.69      38.57
        4  secundaria                           |    9588525      33.56      35.32      73.89
        5  básica especial                      |      45729       0.16       0.17      74.06
        6  superior no universitaria incompleta |    1114858       3.90       4.11      78.17
        7  superior no universitaria completa   |    1838660       6.43       6.77      84.94
        8  superior universitaria incompleta    |    1384782       4.85       5.10      90.04
        9  superior universitaria completa      |    2375799       8.31       8.75      98.79
        10 maestría / doctorado                 |     327275       1.15       1.21     100.00
        Total                                   |   2.71e+07      95.00     100.00           
Missing .                                       |    1429609       5.00                      
Total                                           |   2.86e+07     100.00                      
---------------------------------------------------------------------------------------------
*/
recode c5_p13_niv (4 6 7 8 9 10 = 1) (1 2 3 5 = 0), gen(Nivel_secundaria_más_17)

** Years of Schooling
br c5_p13_niv c5_p13_gra c5_p13_anio_pri c5_p13_anio_sec
egen    tmp_years=rowmax(c5_p13_gra c5_p13_anio_pri c5_p13_anio_sec)
gen     Schooling= 0             if (c5_p13_niv<= 2)                // Sin nivel e Inicial
replace Schooling=     tmp_years if (c5_p13_niv== 3 & tmp_years<6)  // primaria
replace Schooling= 6 + tmp_years if (c5_p13_niv== 4 & tmp_years<=5) // secundaria
replace Schooling=11 + 1.5       if (c5_p13_niv== 6 & c5_p13_niv!=. & tmp_years!=.) // superior no universitaria incompleta
replace Schooling=11 + 3         if (c5_p13_niv== 7 & c5_p13_niv!=. & tmp_years!=.) // superior no universitaria completa
replace Schooling=11 + 2.5       if (c5_p13_niv== 8 & c5_p13_niv!=. & tmp_years!=.) // superior universitaria incompleta 
replace Schooling=11 + 5         if (c5_p13_niv== 9 & c5_p13_niv!=. & tmp_years!=.) // superior universitaria completa
replace Schooling=16 + 2         if (c5_p13_niv==10 & c5_p13_niv!=. & tmp_years!=.) // maestría / doctorado

* Porcentaje Personas que no saben leer ni escribir 
preserve
	keep if c5_p4_1>=6 // p: edad en años

	collapse (mean) No_leer_escribir [iw=id_pob_imp_f], by(ubigeo)
	
	save "$Output\No saben leer ni escribir.dta", replace
restore

* Porcentaje población que asiste una IE en otro distrito
preserve
	* (2  inicial) (3  primaria) (4  secundaria) (5  básica especial)
	keep if c5_p13_niv==2 | c5_p13_niv==3 | c5_p13_niv==4 | c5_p13_niv==5 // c5_p13_niv -- p3a+: Último nivel de estudio que aprobó 
	keep if c5_p14==1 // p3a+:  actualmente - asiste a algún colegio, instituto o universidad
	drop if c5_p15==. // p3a+: la institución educativa al que asiste está ubicada:

	collapse (mean) Asiste_IE_otro_distrito [iw=id_pob_imp_f], by(ubigeo)
	
	save "$Output\Asiste a una IE en otro distrito.dta", replace
restore

* Porcentaje personas de 17 a más años que no culminaron el nivel secundario
preserve
	keep if c5_p4_1>=17 // p: edad en años
	
	collapse (mean) Nivel_secundaria_más_17 [iw=id_pob_imp_f], by(ubigeo)	
	
	save "$Output\Nivel secundaria alcanzada más 17 años.dta", replace
restore

* Años promedios de escolaridad de 3 a 17 años
preserve
	keep if c5_p4_1>=17 // p: edad en años
	
	collapse (mean) Schooling [iw=id_pob_imp_f], by(ubigeo)	
	
	save "$Output\Años promedios de escolaridad.dta", replace	
restore

* Porcentaje de Hogar con personas de 6 a 17 años que no estudian 
*preserve
*restore

********************************************************************************
********************************************************************************
* Variable 11
* Porcentaje de locales educativos con acceso al servicio de energía eléctrica en el local educativo por Red pública de electricidad dentro del local educativo y Red pública de electricidad fuera del local educativo, pero dentro de la edificación
* Variable 12
* Porcentaje de locales educativos que cuentan con al menos un aula acondicionada en estado de conservación de tipo bueno o regular.
* Variable 13
* Porcentaje de locales educativos que cuentan con al menos una PC, Tablet y/o Laptop convencional.
* Variable 14
* Años de existencia de la infraestructura
* Variable 15
* Porcentaje de locales educativos inscritos en los Registros Públicos
* Variable 16
* Porcentaje de locales educativos con el material predominante en las paredes del local educativo de Ladrillo o bloque de cemento y Piedra o sillar con cal o cemento
* Variable 17
* Porcentaje de locales educativos con el material predominante en el piso del local educativo de Parquet o madera pulida, Láminas asfálticas, vinílicos o similares, Losetas, terrazos, cerámicos o similares, Madera (pona, tornillo, etc.) y Cemento
* Variable 18
* Porcentaje de locales educativos con el material predominante en el techo del local educativo de Concreto armado, Madera, Tejas y Planchas de calamina, fibra de cemento o similares
* Variable 19
* Porcentaje de locales educativos con abastecimiento de agua del local educativo por Red pública, Red pública dentro de la vivienda, Red pública fuera de la vivienda, pero dentro de la edificación y Pilón o pileta de uso público
* Variable 20
* Porcentaje de locales educativos con eliminación de excretas del local educativo a través de Red pública de desagüe dentro del local educativo y Red pública de desagüe fuera del local educativo, pero dentro de la edificación
* Variable 21
* Porcentaje de locales educativos con acceso al servicio de energía eléctrica del local educativo por Red pública de electricidad dentro del local educativo y Red pública de electricidad fuera del local educativo, pero dentro de la edificación
* Variable 22
* Porcentaje promedio de aulas de clases que cuenta con el servicio eléctrico operativo; es decir, disponible en el momento oportuno de uso.
* Variable 23
* Porcentaje de locales educativos que no cuentan con cerco perimétrico
* Variable 24
* Cantidad de locales educativos
* Variable 25
* Porcentaje de instituciones educativas a nivel inicial en condiciones inadecuadas
* Variable 26
* Porcentaje de instituciones educativas a nivel primario en condiciones inadecuadas
* Variable 27
* Porcentaje de instituciones educativas a nivel secundario en condiciones inadecuadas
********************************************************************************
********************************************************************************



********************************************************************************
********************************************************************************

use "$Output\No saben leer ni escribir.dta", replace

merge 1:1 ubigeo using "$Output\Asiste a una IE en otro distrito.dta", nogen
merge 1:1 ubigeo using "$Output\Nivel secundaria alcanzada más 17 años.dta", nogen
merge 1:1 ubigeo using "$Output\Años promedios de escolaridad.dta", nogen

save "$Output\03 Servicios de educación básica.dta", replace





