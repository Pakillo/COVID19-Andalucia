
fecha.distri <- as.Date("2020-05-06")

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
    #mutate(Medida = ifelse(Medida == "Confirmados total", "Confirmados", Medida)) %>%
    #mutate(Medida = ifelse(Medida == "Defunciones total", "Defunciones", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Confirmado PCR", "Confirmados PCR", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Defunciones", "Defunciones total", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Confirmados Acumulados en 14 días",
                           "Confirmados < 14 días", Medida)) %>%
    tidyr::pivot_wider(names_from = "Medida", values_from = "Valor") %>%
    mutate(Fecha = fecha.distri) %>%
    dplyr::select(Fecha, Lugar, `Confirmados PCR`, `Confirmados PCR <14 días`,
                  `Confirmados total`, `Confirmados < 14 días`, `Defunciones total`)

  muni.dia %>%
    assertr::verify(all.equal(names(muni.dia), names(muni.data)))

  muni.data <- dplyr::bind_rows(muni.data, muni.dia) %>%
    readr::write_csv(path = "datos/municipios.csv")

}

