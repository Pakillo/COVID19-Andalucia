
fecha.distri <- as.Date("2020-05-03")

rmarkdown::render("evolucion-coronavirus-andalucia.Rmd")


## Datos municipios

library(dplyr)

muni.data <- readr::read_csv("datos/municipios.csv")

if (!fecha.distri %in% muni.data$Fecha) {

  munis.dia <- list.files("datos/municipios.dia/", pattern = ".csv", full.names = TRUE)

  muni.dia <- purrr::map_df(munis.dia, readr::read_csv2) %>%
    rename(Lugar = `Lugar de residencia`) %>%
    dplyr::select(-X4) %>%
    dplyr::filter(!is.na(Lugar), Medida != "Población") %>%
    mutate(Medida = ifelse(Medida == "Confirmados total", "Confirmados", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Defunciones total", "Defunciones", Medida)) %>%
    tidyr::pivot_wider(names_from = "Medida", values_from = "Valor") %>%
    mutate(Fecha = fecha.distri) %>%
    dplyr::select(Fecha, everything())

  muni.data <- dplyr::bind_rows(muni.data, muni.dia) %>%
    readr::write_csv(path = "datos/municipios.csv")

}

