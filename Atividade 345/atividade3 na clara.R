## Prática 3: acessando os bancos de dados abertos, verificando a ocorrência, inspecionando dados
##  avaliando a qualidade e por fim um mapa de ocorrência ##


library(tidyverse)
install.packages("rgbif")
library(rgbif)
install.packages("leaflet")
library(leaflet)
library(ggplot2)
library(dplyr)

##checar funções
?occ_data

## Baixar as ocorrências ##

paru_gbif <- occ_data(scientificName = "Pomacanthus paru",
                      hasCoordinate= TRUE,
                      hasGeospatialIssue=FALSE)

dim(paru_gbif)

dim(paru_gbif$data)

paru_gbif$data %>% names

issues_gbif <- paru_gbif$data$issues %>%
  unique()
gbif_issues() %>%
  data.frame() %>% 
  filter(code %in% issues_gbif) 

## Agora vou selecionar variaveus e investigar ##

paru_gbif1 <- paru_gbif$data %>%
  dplyr::select(scientificName, acceptedScientificName, decimalLatitude, decimalLongitude,
                issues, waterBody, basisOfRecord, occurrenceStatus, rightsHolder, 
                datasetName, recordedBy, depth, locality, habitat) %>% 
  distinct()
lapply(paru_gbif1, unique)

paru_gbif_ok <- paru_gbif1

## Instalar e carregar os pacotes para os mapas ##

install.packages("ggmap")
install.packages("maps")
install.packages("mapdata")
library(ggmap)
library(maps)
library(mapdata)
world <-map_data('world')

ggplot() +
  geom_polygon(data = world, aes(x = long, y = lat, group = group)) +
  coord_fixed() +
  theme_classic() +
  geom_point(data = paru_gbif_ok, aes(x = decimalLongitude, y = decimalLatitude), color = "light blue") +
  labs(x = "longitude", y = "latitude", title = expression(italic("Pomacanthus paru")))

## Agora vai pro OBIS ##

install.packages("robis")
library(robis)

## baixar ocorrência ##

paru_obis <- robis::occurrence("Pomacanthus paru")

## checar os nomes das colunas ##

names(paru_obis)

paru_obis1 <- paru_obis %>% 
  dplyr::select(scientificName, decimalLatitude, decimalLongitude, bathymetry,
                flags, waterBody, basisOfRecord, occurrenceStatus, rightsHolder, 
                datasetName, recordedBy, depth, locality, habitat) %>% 
  distinct()

paru_obis1 %>% 
  distinct(flags)

paru_obis1 %>% 
  filter(!flags %in% c("on_land,no_depth","no_depth,on_land", "on_land", "on_land,depth_exceeds_bath", "depth_exceeds_bath,on_land"),
         !is.na(datasetName)) %>% 
  lapply(., unique)

paru_obis_ok <- paru_obis1 %>% 
  dplyr::filter(!flags %in% c("on_land,no_depth","no_depth,on_land", "on_land", "on_land,depth_exceeds_bath", "depth_exceeds_bath,on_land"),
                !is.na(datasetName))

ggplot() +
  geom_polygon(data = world, aes(x = long, y = lat, group = group)) +
  coord_fixed() +
  theme_classic() +
  geom_point(data = paru_obis_ok, aes(x = decimalLongitude, y = decimalLatitude, color = waterBody)) +
  labs(x = "longitude", y = "latitude", title = expression(italic("Pomacanthus paru")))

all_data <- bind_rows(paru_gbif_ok %>% 
                        mutate(repo = paste0("gbif", row.names(.))), 
                      paru_obis_ok %>% 
                        mutate(repo = paste0("obis", row.names(.)))) %>%
  column_to_rownames("repo") %>% 
  dplyr::select(decimalLongitude, decimalLatitude, depth) %>% 
  distinct() %>% 
  rownames_to_column("occ") %>% 
  separate(col = "occ", into = c("datasetName", "rn"), sep = 4) %>%
  mutate(scientificName = "Pomacanthus paru") %>% 
  dplyr::select(-rn)

ggplot() +
  geom_polygon(data = world, aes(x = long, y = lat, group = group)) +
  coord_fixed() +
  theme_classic() +
  geom_point(data = all_data, aes(x = decimalLongitude, y = decimalLatitude, color = datasetName)) +
  theme(legend.title = element_blank()) +
  labs(x = "longitude", y = "latitude", title = expression(italic("Pomacanthus paru")))

write.csv(all_data, "occ_GBIF-OBIS_par_hepa.csv", row.names = FALSE)



### EXTRA: Classificação automática dos pontos ###


# função para classificar ocorrencias suspeitas

flag_outlier <- function(df, species){
  dados <- df %>% 
    dplyr::filter(scientificName == species); 
  
  dados2 <- geosphere::distVincentyEllipsoid(
    dados %>%
      summarise(centr_lon = median(decimalLongitude),
                centr_lat = median(decimalLatitude)),
    dados %>% 
      dplyr::select(decimalLongitude, decimalLatitude)
  ) %>% 
    bind_cols(dados) %>% 
    rename(dist_centroid = '...1') %>% 
    mutate(flag = ifelse(dist_centroid < quantile(dist_centroid, probs = 0.9), "OK",
                         ifelse(dist_centroid >= quantile(dist_centroid, probs = 0.90) & dist_centroid < quantile(dist_centroid, probs = 0.95), "check > Q90",
                                ifelse(dist_centroid >= quantile(dist_centroid, probs = 0.95), "check > Q95", "OK"))))
  
  print(dados2)
  
}

marcados <- paru_gbif$data %>% 
  data.frame() %>% 
  dplyr::select(scientificName, decimalLongitude, decimalLatitude, datasetName) %>% 
  distinct() %>% 
  flag_outlier(., "Paracanthurus hepatus (Linnaeus, 1766)")



