
library(dplyr)

## Datos municipios

fecha.munis <- as.Date("2020-06-30")

muni.data <- readr::read_csv("datos/municipios.csv", guess_max = 10000)

munis <- readr::read_csv("datos/muni_prov_dist.csv")


if (!fecha.munis %in% as.Date(muni.data$Fecha)) {

  munis.dia <- list.files("datos/municipios.dia/", pattern = ".csv", full.names = TRUE)

  muni.dia <- purrr::map_df(munis.dia, readr::read_csv2) %>%
    rename(Municipio = `Lugar de residencia`) %>%
    dplyr::select(-X4) %>%
    dplyr::filter(!is.na(Municipio), Municipio %in% unique(muni.data$Municipio)) %>%
    dplyr::filter(!is.na(Medida)) %>%
    assertr::verify(unique(.$Medida) ==
                      c("Población", "Confirmados PCR",
                        "Confirmados PCR 14 días", "Confirmados PCR 7 días",
                        "Fallecidos", "Curados", "Total Confirmados",
                        "Confirmado PCR")) %>%
    mutate(Medida = ifelse(Medida == "Confirmado PCR", "Confirmados PCR", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Confirmados PCR 14 días", "ConfirmadosPCR14d", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Total Confirmados", "Confirmados total", Medida)) %>%
    dplyr::filter(Medida == "Confirmados PCR" | Medida == "Confirmados total" | Medida == "Fallecidos" | Medida = "ConfirmadosPCR14d") %>%
    tidyr::pivot_wider(names_from = "Medida", values_from = "Valor") %>%
    rename(ConfirmadosPCR = `Confirmados PCR`,
           ConfirmadosTotal = `Confirmados total`,
           Defunciones = Fallecidos) %>%
    mutate(Fecha = fecha.munis) %>%
    right_join(munis, by = "Municipio") %>%
    dplyr::select(Fecha, Provincia, Distrito, Municipio,
                  ConfirmadosPCR, ConfirmadosPCR14d, ConfirmadosTotal, Defunciones)


  muni.dia %>%
    assertr::verify(all.equal(names(muni.dia), names(muni.data)))

  muni.data <- dplyr::bind_rows(muni.data, muni.dia) %>%
    arrange(Fecha, Provincia, Distrito, Municipio) %>%
    readr::write_csv(path = "datos/municipios.csv")

}


## Render

rmarkdown::render("evolucion-coronavirus-andalucia.Rmd")


