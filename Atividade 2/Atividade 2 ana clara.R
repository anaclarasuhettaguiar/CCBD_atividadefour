install.packages("vegan")
library(vegan)
install.packages("dplyr")
library(dplyr)
install.packages("ggplot")
library(ggplot2)
install.packages("tidyr")
library(tidyr)
install.packages("validate")
library(validate)
install.packages("taxize")
library(taxize)


setwd ("C:/Users/anacl/OneDrive/?rea de Trabalho/ciencia_colab")
iris <- read.csv ("atividade1.csv", header = T, sep = ";")

str(iris)
lapply(iris, unique)

iris %>% 
  select(esp?cie, sepal_lenght:petal_width) %>% 
  pivot_longer(cols = -esp?cie, names_to = "variavel", values_to = "valores") %>% 
  ggplot(aes(y = valores, fill = esp?cie)) +
  geom_histogram() +
  facet_wrap(~ variavel, scales = 'free_y') +
  theme_classic()

rules <- validator(in_range(lat, min = -90, max = 90),
                   in_range(lat, min = -180, max = 180),
                   is.character(site),
                   is.numeric(date),
                   all_complete(iris))

out   <- confront(iris, rules)
summary(out)

plot (out)

esp?cie <- iris %>% 
  distinct(esp?cie) %>% 
  pull() %>% 
  get_tsn() %>% 
  data.frame() %>% 
  bind_cols(iris %>% 
              distinct(esp?cie))

## Entrando na Planilha base com o DarwinCore ###

iris_1 <- iris %>% 
  dplyr::mutate(eventID = paste(site, data, sep = "_"), # create indexing fields 
                occurrenceID = paste(site, data, amostra, sep = "_")) %>% 
  left_join(esp?cie %>% 
              select(esp?cie, uri)) %>% # add species unique identifier
  dplyr::rename(decimalLongitude = longitude, # rename fields according to DwC 
                decimalLatitude = latitude,
                eventDate = data,
                scientificName = esp?cie,
                scientificNameID = uri) %>% 
  mutate(geodeticDatum = "WGS84", # and add complimentary fields
         verbatimCoordinateSystem = "decimal degrees",
         georeferenceProtocol = "Random coordinates obtained from Google Earth",
         locality = "Gaspe Peninsula",
         recordedBy = "Edgar Anderson",
         taxonRank = "esp?cie",
         organismQuantityType = "individuals",
         basisOfRecord = "Human observation")
## Criando a planilha de eventos ##

eventCore <- iris_1 %>% 
  select(eventID, eventDate, decimalLongitude, decimalLatitude, locality, site,
         geodeticDatum, verbatimCoordinateSystem, georeferenceProtocol) %>% 
  distinct() 

## Criando a planilha de ocorr?ncias ##

occurrences <- iris_1 %>% 
  select(eventID, occurrenceID, scientificName, scientificNameID,
         recordedBy, taxonRank, organismQuantityType, basisOfRecord) %>%
  distinct() 

## Criando a planilha de atributos ##

eMOF <- iris_1 %>% 
  select(eventID, occurrenceID, recordedBy, sepal_length:petal_width) %>%  
  pivot_longer(cols = sepal_length:petal_width,
               names_to = "measurementType",
               values_to = "measurementValue") %>% 
  mutate(measurementUnit = "cm",
         measurementType = plyr::mapvalues(measurementType,
                                           from = c("sepal_length", "sepal_width", "petal_width", "petal_length"), 
                                           to = c("sepal length", "sepal width", "petal width", "petal length")))


### Controle de qualidade ##

# Checando todos os eventos combinados

setdiff(eventCore$eventID, occurrences$eventID)
setdiff(eventCore$eventID, eMOF$eventID)
setdiff(occurrences$eventID, eMOF$eventID)

## Checando colunas com NA

eMOF %>%
  filter(is.na(eventID))

occurrences %>%
  filter(is.na(eventID))

## Criando os arquivos de texto ##

rm(list = setdiff(ls(), c("eventCore", "occurrences", "eMOF")))

files <- list(eventCore, occurrences, eMOF) 
data_names <- c("DF_eventCore","DF_occ","DF_eMOF")
dir.create("Dwc_Files")


for(i in 1:length(files)) {
  path <- paste0(getwd(), "/", "DwC_Files")
  write.csv(files[[i]], paste0(path, "/", data_names[i], ".csv"))
}


