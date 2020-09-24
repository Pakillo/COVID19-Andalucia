
library(dplyr)

## Datos municipios

fecha.munis <- as.Date("2020-09-23")


muni.data <- readr::read_csv("datos/municipios.csv", guess_max = 50000)

munis <- readr::read_csv("datos/muni_prov_dist.csv")


if (!fecha.munis %in% as.Date(muni.data$Fecha)) {

  munis.dia <- list.files("datos/municipios.dia/", pattern = ".csv", full.names = TRUE)

  muni.dia <- purrr::map_df(munis.dia, readr::read_csv2, col_types = "ccd_") %>%
    rename(Municipio = `Lugar de residencia`) %>%
    #dplyr::select(-X4) %>%
    dplyr::filter(!is.na(Municipio), Municipio %in% unique(muni.data$Municipio)) %>%
    dplyr::filter(!is.na(Medida)) %>%
    dplyr::filter(Medida != "Tasa PCR 14 días", Medida != "Población") %>%
    assertr::verify(unique(.$Medida) ==
                      c("Confirmados PCR",
                        "Confirmados PCR 14 días",
                        "Confirmados PCR 7 días",
                        "Total Confirmados",
                        "Curados",
                        "Fallecidos")) %>%
    mutate(Medida = ifelse(Medida == "Confirmados PCR 14 días", "ConfirmadosPCR14d", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Total Confirmados", "Confirmados total", Medida)) %>%
    dplyr::filter(Medida == "Confirmados PCR" | Medida == "Confirmados total" | Medida == "Fallecidos" | Medida == "ConfirmadosPCR14d") %>%
    #mutate(Valor = ifelse(is.na(Valor), 0, Valor)) %>%
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


