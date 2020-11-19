
## Especificar fecha de datos
fecha.munis <- as.Date("2020-11-18")

fecha.edad <- as.Date("2020-11-12")


library(dplyr)


#### Datos municipios ####

muni.data <- readr::read_csv("datos/municipios.csv",
                             col_types = "Dcccddddd",
                             guess_max = 50000)

munis <- readr::read_csv("datos/muni_prov_dist.csv")


if (!fecha.munis %in% as.Date(muni.data$Fecha)) {

  munis.dia <- list.files("datos/municipios.dia/", pattern = ".csv", full.names = TRUE)

  muni.dia <- purrr::map_df(munis.dia, readr::read_csv2, col_types = "ccd_") %>%
    rename(Municipio = `Lugar de residencia`) %>%
    #dplyr::select(-X4) %>%
    dplyr::filter(!is.na(Municipio), Municipio %in% unique(muni.data$Municipio)) %>%
    dplyr::filter(!is.na(Medida)) %>%
    dplyr::filter(Medida != "Población") %>%
    assertr::verify(unique(.$Medida) ==
                      c("Confirmados PDIA",
                        "Confirmados PDIA 14 días",
                        "Tasa PDIA 14 días",
                        "Confirmados PDIA 7 días",
                        "Total Confirmados",
                        "Curados",
                        "Fallecidos")) %>%
    mutate(Medida = ifelse(Medida == "Tasa PDIA 14 días", "Conf14d_100.000hab", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Confirmados PDIA", "Confirmados.PCR.TA", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Confirmados PDIA 14 días", "Confirmados.PCR.TA.14d", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Total Confirmados", "ConfirmadosTotal", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Fallecidos", "Defunciones", Medida)) %>%
    dplyr::filter(Medida == "Confirmados.PCR.TA" | Medida == "Confirmados.PCR.TA.14d" |
                    Medida == "Conf14d_100.000hab" |
                    Medida == "ConfirmadosTotal" | Medida == "Defunciones") %>%
    tidyr::pivot_wider(names_from = "Medida", values_from = "Valor") %>%
    mutate(Fecha = fecha.munis) %>%
    right_join(munis, by = "Municipio") %>%
    dplyr::select(Fecha, Provincia, Distrito, Municipio,
                  Confirmados.PCR.TA, Confirmados.PCR.TA.14d, Conf14d_100.000hab,
                  ConfirmadosTotal, Defunciones)

  muni.dia %>%
    assertr::verify(all.equal(names(muni.dia), names(muni.data)))

  muni.data <- dplyr::bind_rows(muni.data, muni.dia) %>%
    arrange(Fecha, Provincia, Distrito, Municipio) %>%
    readr::write_csv(file = "datos/municipios.csv")

}




#### Casos, Ingresados, Defunciones, etc por edad

datos.edad.sexo <- readr::read_csv("datos/datos_edad_sexo.csv")

if (!fecha.edad %in% as.Date(datos.edad.sexo$Fecha)) {

casos.dia <- readr::read_csv2("datos/edad.sexo/datos_casos_edad_sexo.csv",
                              col_types = "cccd_") %>%
  filter(Medida != "% pirámide") %>%
  rename(Confirmados = Valor) %>%
  select(-Medida) %>%
  mutate(Fecha = fecha.edad) %>%
  relocate(Fecha)

hosp.dia <- readr::read_csv2("datos/edad.sexo/datos_hosp_edad_sexo.csv",
                              col_types = "cccd_") %>%
  filter(Medida != "% pirámide") %>%
  rename(Hospitalizados = Valor) %>%
  select(-Medida) %>%
  mutate(Fecha = fecha.edad) %>%
  relocate(Fecha)

uci.dia <- readr::read_csv2("datos/edad.sexo/datos_uci_edad_sexo.csv",
                             col_types = "cccd_") %>%
  filter(Medida != "% pirámide") %>%
  rename(UCI = Valor) %>%
  select(-Medida) %>%
  mutate(Fecha = fecha.edad) %>%
  relocate(Fecha)

def.dia <- readr::read_csv2("datos/edad.sexo/datos_def_edad_sexo.csv",
                             col_types = "cccd_") %>%
  filter(Medida != "% pirámide") %>%
  rename(Defunciones = Valor) %>%
  select(-Medida) %>%
  mutate(Fecha = fecha.edad) %>%
  relocate(Fecha)

datos.edad.sexo.dia <- casos.dia %>%
  left_join(hosp.dia, by = c("Fecha", "Edad", "Sexo")) %>%
  left_join(uci.dia, by = c("Fecha", "Edad", "Sexo")) %>%
  left_join(def.dia, by = c("Fecha", "Edad", "Sexo"))

datos.edad.sexo.dia %>%
  assertr::verify(all.equal(names(datos.edad.sexo.dia), names(datos.edad.sexo)))

datos.edad.sexo <- dplyr::bind_rows(datos.edad.sexo, datos.edad.sexo.dia) %>%
  arrange(Fecha, Edad, Sexo) %>%
  readr::write_csv(file = "datos/datos_edad_sexo.csv")

}




## Render

rmarkdown::render("evolucion-coronavirus-andalucia.Rmd")


