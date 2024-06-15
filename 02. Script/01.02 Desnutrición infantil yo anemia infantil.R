# Indicaciones: Para ejecutar el script, es necesario instalar las librerias y modificar la ruta de trabajo
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

# Clear all
rm(list = ls())

# Libraries
library(readxl)
library(dplyr)
library(haven)
library(fs)

# Global paths
Path   <- "E:/03. Job/05. CONSULTORIAS/13. MEF/FIDT_2024"
Ubigeo <- file.path(Path, "01. Input/00. Dataset/00. Ubigeo")
INS    <- file.path(Path, "01. Input/00. Dataset/03. INS")
Output <- file.path(Path, "01. Input/02. Desnutrición infantil yo anemia infantil")

leer_csv <- function(archivos) {
  lapply(archivos, read.csv)
}

################################################################################
################################################################################
# Porcentaje de desnutrición crónica en niños menores de 5 años
# https://www.minsa.gob.pe/reunis/data/sien-hisminsa-5.asp
# https://www.gob.pe/institucion/ins/informes-publicaciones/4201302-indicadores-ninos-enero-diciembre-2022-base-de-datos-his-minsa
################################################################################
################################################################################

# Importing database
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Path_PT <- file.path(INS, "PT- 2023_CD 2-20240524T060922Z-001/PT- 2023_CD 2/PT")

Archivos_PT <- list.files(path = Path_PT, pattern = "\\.csv$", full.names = TRUE)

Datos_PT <- leer_csv(Archivos_PT)

Datos_PT_completo <- do.call(rbind, Datos_PT)

colnames(Datos_PT_completo)

table(Datos_PT_completo$Dx_TE)

Datos_PT_completo$Total                <- 1
Datos_PT_completo$Desnutricion_cronica <- ifelse(Datos_PT_completo$Dx_TE == 'D.Crónica', 1, 0)
Datos_PT_completo$Desnutricion_normal  <- ifelse(Datos_PT_completo$Dx_TE == 'Normal', 1, 0)

Datos_PT_completo <- Datos_PT_completo %>% rename(ubigeo = UbigeoREN)

Datos_PT_completo <- Datos_PT_completo %>% mutate(ubigeo = as.character(ubigeo))
Datos_PT_completo$ubigeo <- ifelse(nchar(Datos_PT_completo$ubigeo) == 5, paste0("0", Datos_PT_completo$ubigeo), Datos_PT_completo$ubigeo)

# Colapsando la data
desnutricion_data <- Datos_PT_completo %>%
  group_by(ubigeo, DepartamentoREN, ProvinciaREN, DistritoREN) %>%
  summarise(Total                          = sum(Total, na.rm = TRUE), 
            Población_Desnutricion_cronica = sum(Desnutricion_cronica, na.rm = TRUE),            
            Población_Desnutricion_normal  = sum(Desnutricion_normal, na.rm = TRUE)) %>%
  ungroup()

desnutricion_data$Total                          <- as.numeric(desnutricion_data$Total)
desnutricion_data$Población_Desnutricion_cronica <- as.numeric(desnutricion_data$Población_Desnutricion_cronica)
desnutricion_data$Población_Desnutricion_normal  <- as.numeric(desnutricion_data$Población_Desnutricion_normal)

desnutricion_data$Desnutricion_cromica <- desnutricion_data$Población_Desnutricion_cronica/desnutricion_data$Total

#write_dta(desnutricion_data, file.path(Output, "Desnutrición.dta"))

################################################################################
################################################################################
# Porcentaje de anemia total en niños entre 6 y 35 meses
# https://www.minsa.gob.pe/reunis/data/sien-hisminsa-estado-nuticional-gestantes.asp
# https://www.gob.pe/institucion/ins/informes-publicaciones/4201301-indicadores-gestantes-enero-diciembre-2022-base-de-datos-sien
################################################################################
################################################################################

# Importing database
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Path_HB <- file.path(INS, "HB 2023_CD 1-20240524T060924Z-001/HB 2023_CD 1/HB")

Archivos_HB <- list.files(path = Path_HB, pattern = "\\.csv$", full.names = TRUE)

Datos_HB <- leer_csv(Archivos_HB)

Datos_HB_completo <- do.call(rbind, Datos_HB)

colnames(Datos_HB_completo)

table(Datos_HB_completo$Dx_anemia)

Datos_HB_completo$Total           <- 1
Datos_HB_completo$Anemia_Leve     <- ifelse(Datos_HB_completo$Dx_anemia == 'Anemia Leve', 1, 0)
Datos_HB_completo$Anemia_Moderada <- ifelse(Datos_HB_completo$Dx_anemia == 'Anemia Moderada', 1, 0)
Datos_HB_completo$Anemia_Severa   <- ifelse(Datos_HB_completo$Dx_anemia == 'Anemia Severa', 1, 0)
Datos_HB_completo$Normal          <- ifelse(Datos_HB_completo$Dx_anemia == 'Normal ', 1, 0)

Datos_HB_completo <- Datos_HB_completo %>% rename(ubigeo = UbigeoREN)

Datos_HB_completo <- Datos_HB_completo %>% mutate(ubigeo = as.character(ubigeo))
Datos_HB_completo$ubigeo <- ifelse(nchar(Datos_HB_completo$ubigeo) == 5, paste0("0", Datos_HB_completo$ubigeo), Datos_HB_completo$ubigeo)

# Colapsando la data
anemia_data <- Datos_HB_completo %>%
  group_by(ubigeo, DepartamentoREN, ProvinciaREN, DistritoREN) %>%
  summarise(Total           = sum(Total, na.rm = TRUE), 
            Anemia_Leve     = sum(Anemia_Leve, na.rm = TRUE),            
            Anemia_Moderada = sum(Anemia_Moderada, na.rm = TRUE),
            Anemia_Severa   = sum(Anemia_Severa, na.rm = TRUE)) %>%
  ungroup()

anemia_data$Total           <- as.numeric(anemia_data$Total)
anemia_data$Anemia_Leve     <- as.numeric(anemia_data$Anemia_Leve)
anemia_data$Anemia_Moderada <- as.numeric(anemia_data$Anemia_Moderada)
anemia_data$Anemia_Severa   <- as.numeric(anemia_data$Anemia_Severa)

anemia_data$Anemia_Total <- anemia_data$Anemia_Leve +
                            anemia_data$Anemia_Moderada +
                            anemia_data$Anemia_Severa

anemia_data$Anemia_total <- anemia_data$Anemia_Total/anemia_data$Total

#write_dta(anemia_data, file.path(Output, "Anemia.dta"))

################################################################################
################################################################################
################################################################################
################################################################################

# Merging datasets
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

ubigeo_data <- read_dta(file.path(Ubigeo, "UBIGEO 2022.dta"))

merged_data <- ubigeo_data %>%
  left_join(desnutricion_data %>% select(ubigeo, Desnutricion_cromica), by = "ubigeo") %>%
  left_join(anemia_data %>% select(ubigeo, Anemia_total), by = "ubigeo")

# Save
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

#write_dta(merged_data, file.path(Output, "02_Desnutrición_infantil_yo_anemia_infantil_all.dta"))

merged_data <- merged_data %>% select(-REGION, -PROVINCIA, -DISTRITO)

#write_dta(merged_data, file.path(Output, "02_Desnutrición_infantil_yo_anemia_infantil.dta"))


################################################################################
################################################################################
################################################################################
################################################################################


# Clear all
# rm(list = ls())

# Libraries
# library(readxl)
# library(dplyr)
# library(haven)

# Global paths
# Path   <- "E:/03. Job/05. CONSULTORIAS/13. MEF/FIDT_2024"
# Ubigeo <- file.path(Path, "01. Input/00. Dataset/00. Ubigeo")
# INS    <- file.path(Path, "01. Input/00. Dataset/03. INS")
# Output <- file.path(Path, "01. Input/02. Desnutrición infantil yo anemia infantil")

# ******************************************************************************
# Porcentaje de desnutrición crónica en niños menores de 5 años
# ******************************************************************************

# Importing database
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# desnutricion_data <- read_excel(file.path(INS, "Indicadores Niños Enero – Diciembre (Base de Datos HIS-Minsa).xlsx"), 
#                               sheet = "EN 0-59m x DISTRITO")

# colnames(desnutricion_data)[c(4, 5, 6)] <- c("ubigeo", "Población_evaluados", "Población_desnutricion_cromica")
# desnutricion_data <- desnutricion_data %>% select(ubigeo, Población_evaluados, Población_desnutricion_cromica)

# Filtering data
#''''''''''''''' 
# desnutricion_data <- desnutricion_data %>%
#   filter(!(ubigeo == "UBIGEO" & Población_evaluados == "INDICADOR TALLA / EDAD1" & Población_desnutricion_cromica == "")) %>%
#   filter(!(ubigeo == "" & Población_evaluados == "" & Población_desnutricion_cromica == "")) %>%
#   filter(ubigeo != "")

# Filtering data
#''''''''''''''' 
# desnutricion_data <- desnutricion_data %>%
#   filter(!(ubigeo == "UBIGEO" & Población_evaluados == "INDICADOR TALLA / EDAD1" & Población_desnutricion_cromica == "")) %>%
#   filter(!(ubigeo == "" & Población_evaluados == "" & Población_desnutricion_cromica == "")) %>%
#   filter(ubigeo != "")

# desnutricion_data$Población_evaluados <- as.numeric(desnutricion_data$Población_evaluados)
# desnutricion_data$Población_desnutricion_cromica <- as.numeric(desnutricion_data$Población_desnutricion_cromica)

# desnutricion_data <- desnutricion_data %>% mutate(Desnutricion_cromica = Población_desnutricion_cromica / Población_evaluados)

# Saving data
# write_dta(desnutricion_data, file.path(Output, "Desnutrición.dta"))

# ******************************************************************************
# Porcentaje de anemia total en niños entre 6 y 35 meses
# ******************************************************************************

# Importing database
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# anemia_data <- read_excel(file.path(INS, "Indicadores Niños Enero – Diciembre (Base de Datos HIS-Minsa).xlsx"), 
#                           sheet = "Anemia 6-35m x DISTRITO")

# colnames(anemia_data)[c(4, 5, 6)] <- c("ubigeo", "Población_evaluados", "Población_anemia_total")
# anemia_data <- anemia_data %>% select(ubigeo, Población_evaluados, Población_anemia_total)

# Filtering data
#''''''''''''''' 
# anemia_data <- anemia_data %>%
#   filter(!(ubigeo == "UBIGEO" & Población_evaluados == "N° DE EVALUADOS" & Población_anemia_total == "ANEMIA TOTAL")) %>%
#   filter(!(ubigeo == "" & Población_evaluados == "" & Población_anemia_total == "")) %>%
#   filter(ubigeo != "")

# anemia_data$Población_evaluados <- as.numeric(anemia_data$Población_evaluados)
# anemia_data$Población_anemia_total <- as.numeric(anemia_data$Población_anemia_total)

# anemia_data <- anemia_data %>% mutate(Anemia_total = Población_anemia_total / Población_evaluados)

# write_dta(anemia_data, file.path(Output, "Anemia.dta"))

################################################################################
################################################################################
################################################################################
################################################################################

# Merging datasets
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

# ubigeo_data <- read_dta(file.path(Ubigeo, "UBIGEO 2022.dta"))

# merged_data <- ubigeo_data %>%
#   left_join(desnutricion_data %>% select(ubigeo, Desnutricion_cromica), by = "ubigeo") %>%
#   left_join(anemia_data %>% select(ubigeo, Anemia_total), by = "ubigeo")

# Save
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

# write_dta(merged_data, file.path(Output, "02_Desnutrición_infantil_yo_anemia_infantil_all.dta"))

# merged_data <- merged_data %>% select(-REGION, -PROVINCIA, -DISTRITO)

# write_dta(merged_data, file.path(Output, "02_Desnutrición_infantil_yo_anemia_infantil.dta"))
