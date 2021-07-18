library(readr)
library(dplyr)
library(tidylog)


## 2021-07-18 ################################################################

## Fixing some minor errors on Municipios data
# (mostly unclear distritos)

muni.data <- read_csv("datos/municipios.csv",
                             col_types = "Dcccddddd",
                             guess_max = 50000)

muni.data <- muni.data %>%
  mutate(Distrito = ifelse(Municipio == "Aldeaquemada", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Andújar", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Arjona", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Arjonilla", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Arquillos", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Bailén", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Baños de la Encina", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Carboneros", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Carolina (La)", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Chiclana de Segura", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Escañuela", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Guarromán", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Jabalquinto", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Lahiguera", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Linares", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Marmolejo", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Montizón", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Navas de San Juan", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Santa Elena", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Santisteban del Puerto", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Sorihuela del Guadalimar", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Torreblascopedro", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Vilches", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Villanueva de la Reina", "Jaén Norte", Distrito),
         Distrito = ifelse(Municipio == "Benahavís", "Costa del Sol", Distrito),
         Distrito = ifelse(Municipio == "Benalmádena", "Costa del Sol", Distrito),
         Distrito = ifelse(Municipio == "Casares", "Costa del Sol", Distrito),
         Distrito = ifelse(Municipio == "Estepona", "Costa del Sol", Distrito),
         Distrito = ifelse(Municipio == "Fuengirola", "Costa del Sol", Distrito),
         Distrito = ifelse(Municipio == "Istán", "Costa del Sol", Distrito),
         Distrito = ifelse(Municipio == "Manilva", "Costa del Sol", Distrito),
         Distrito = ifelse(Municipio == "Marbella", "Costa del Sol", Distrito),
         Distrito = ifelse(Municipio == "Mijas", "Costa del Sol", Distrito),
         Distrito = ifelse(Municipio == "Ojén", "Costa del Sol", Distrito),
         Distrito = ifelse(Municipio == "Torremolinos", "Costa del Sol", Distrito),
         Provincia = ifelse(Municipio == "Chucena", "Huelva", Provincia),
         Provincia = ifelse(Municipio == "Hinojos", "Huelva", Provincia),
         Provincia = ifelse(Municipio == "Peñaflor", "Sevilla", Provincia)
         )

write_csv(muni.data, file = "datos/municipios.csv")


# also fixing province of Chucena, Hinojos & Peñaflor
munis <- read_csv("datos/muni_prov_dist.csv") %>%
  mutate(Provincia = ifelse(Municipio == "Chucena", "Huelva", Provincia),
         Provincia = ifelse(Municipio == "Hinojos", "Huelva", Provincia),
         Provincia = ifelse(Municipio == "Peñaflor", "Sevilla", Provincia)
         ) %>%
  write_csv("datos/muni_prov_dist.csv")




