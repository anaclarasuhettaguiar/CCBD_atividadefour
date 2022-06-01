setwd ("C:/Users/anacl/OneDrive/Área de Trabalho/ciencia_colab")


install.packages("readr")
install.packages("taxize")
library(readr)
library(tidyverse)
library(taxize)


### Editando cada aluno e padronizando as planilhas ###

## ANA

ANA <- read_delim("ANA CLARA.csv", 
                     delim = ";", escape_double = FALSE, trim_ws = TRUE)
## Renomear colunas e formatar coordenadas para igualar tudo
colnames(ANA) <- c("pdf", "amostra", "site", "lat", "lon", "date", "Species", "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
ANA$lat <- sapply(ANA$lat, gsub, pattern = "\\.", replacement= "")
ANA$lat <- as.numeric(ANA$lat)
ANA$lon <- sapply(ANA$lon, gsub, pattern = "\\.", replacement= "")
ANA$lon <- as.numeric(ANA$lat)
ANA$lat <- format(ANA$lat , digits=8,
                     big.mark=";",small.mark=".", big.interval=6)
ANA$lon <- format(ANA$lon , digits=8,
                     big.mark=";",small.mark=".", big.interval=6)


## LETICIA 

LETICIA <- read_delim("LETICIA.csv", 
                       delim = ";", escape_double = FALSE, trim_ws = TRUE)


## Renomear colunas e formatar coordenadas para igualar tudo
colnames(LETICIA) <- c("Amostra", "Amostra arq.", "Esp?cies", "Sepal length (cm)", "Sepal width (cm)", "Petal width (cm)", "Petal length (cm)", "Site", "Latitude", "Longitude", "Data")
LETICIA$lat <- sapply(LETICIA$lat, gsub, pattern = "\\.", replacement= "")
LETICIA$lat <- as.numeric(LETICIA$lat)
LETICIA$lon <- sapply(LETICIA$lon, gsub, pattern = "\\.", replacement= "")
LETICIA$lon <- as.numeric(LETICIA$lat)
LETICIA$lat <- format(LETICIA$lat , digits=8,
                  big.mark=";",small.mark=".", big.interval=6)
LETICIA$lon <- format(LETICIA$lon , digits=8,
                  big.mark=";",small.mark=".", big.interval=6)

## LUIZA 

LUIZA <- read_delim("LUIZA.csv", 
                      delim = ";", escape_double = FALSE, trim_ws = TRUE)

## Renomear colunas e formatar coordenadas para igualar tudo
colnames(LUIZA) <- c("Amostra", "Amostra2", "Site", "Latitude", "Longitude", "Data", "Sepal_length_cm", "Sepal_width_cm", "Petal_lenght_cm", "Petal_widht_cm")
LUIZA$lat <- sapply(LUIZA$lat, gsub, pattern = "\\.", replacement= "")
LUIZA$lat <- as.numeric(LUIZA$lat)
LUIZA$lon <- sapply(LUIZA$lon, gsub, pattern = "\\.", replacement= "")
LUIZA$lon <- as.numeric(LUIZA$lat)
LUIZA$lat <- format(LUIZA$lat , digits=8,
                      big.mark=";",small.mark=".", big.interval=6)
LUIZA$lon <- format(LUIZA$lon , digits=8,
                      big.mark=";",small.mark=".", big.interval=6)



## MARINA MEGA  

MARINA <- read_delim("Marina mega.csv", 
                    delim = ";", escape_double = FALSE, trim_ws = TRUE)


## Renomear colunas e formatar coordenadas para igualar tudo
colnames(MARINA) <- c("sample_card", "sample_pdf", "site", "latitude", "longitude", "date", "specie", "sepal_length_cm", "sepal_widht_cm", "petal_lenght_cm", "petal_widht_cm")
MARINA$lat <- sapply(MARINA$lat, gsub, pattern = "\\.", replacement= "")
MARINA$lat <- as.numeric(MARINA$lat)
MARINA$lon <- sapply(MARINA$lon, gsub, pattern = "\\.", replacement= "")
MARINA$lon <- as.numeric(MARINA$lat)
MARINA$lat <- format(MARINA$lat , digits=8,
                    big.mark=";",small.mark=".", big.interval=6)
MARINA$lon <- format(MARINA$lon , digits=8,
                    big.mark=";",small.mark=".", big.interval=6)


## VICTOR 

VICTOR <- read_delim("VICTOR.csv", 
                     delim = ";", escape_double = FALSE, trim_ws = TRUE)


## Renomear colunas e formatar coordenadas para igualar tudo
colnames(VICTOR) <- c("AmostraArq", "AmostraFicha", "Especie", "Site", "Latitude", "Longitude", "Dia", "Mes", "Ano", "SepLength", "SepWidth", "PetLength", "PetWidth")
VICTOR$lat <- sapply(VICTOR$lat, gsub, pattern = "\\.", replacement= "")
VICTOR$lat <- as.numeric(VICTOR$lat)
VICTOR$lon <- sapply(VICTOR$lon, gsub, pattern = "\\.", replacement= "")
VICTOR$lon <- as.numeric(VICTOR$lat)
VICTOR$lat <- format(VICTOR$lat , digits=8,
                     big.mark=";",small.mark=".", big.interval=6)
VICTOR$lon <- format(VICTOR$lon , digits=8,
                     big.mark=";",small.mark=".", big.interval=6)


## MARIANA

MARIANA <- read_delim("MARIANA.csv", 
                     delim = ";", escape_double = FALSE, trim_ws = TRUE)


## Renomear colunas e formatar coordenadas para igualar tudo
colnames(MARIANA) <- c("Nome do arquivo", "Amostra", "Ano", "M?s", "Dia", "?rea", "Fam?lia", "G?nero", "Esp?cie", "Latitude", "Longitude",
                       "Sepal length (cm)", "Sepal width (cm)", "Petal length (cm)", "Petal width (cm)" )
MARIANA$lat <- sapply(MARIANA$lat, gsub, pattern = "\\.", replacement= "")
MARIANA$lat <- as.numeric(MARIANA$lat)
MARIANA$lon <- sapply(MARIANA$lon, gsub, pattern = "\\.", replacement= "")
MARIANA$lon <- as.numeric(MARIANA$lat)
MARIANA$lat <- format(MARIANA$lat , digits=8,
                     big.mark=";",small.mark=".", big.interval=6)
MARIANA$lon <- format(MARIANA$lon , digits=8,
                     big.mark=";",small.mark=".", big.interval=6)

## Juntando e padronizando as planilhas ##


