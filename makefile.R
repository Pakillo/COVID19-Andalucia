
library(dplyr)

## Datos municipios

fecha.munis <- as.Date("2020-05-28")

muni.data <- readr::read_csv("datos/municipios.csv", guess_max = 10000)

munis <- readr::read_csv("datos/muni_prov_dist.csv")


if (!fecha.munis %in% as.Date(muni.data$Fecha)) {

  munis.dia <- list.files("datos/municipios.dia/", pattern = ".csv", full.names = TRUE)

  muni.dia <- purrr::map_df(munis.dia, readr::read_csv2) %>%
    rename(Municipio = `Lugar de residencia`) %>%
    dplyr::select(-X4) %>%
    dplyr::filter(!is.na(Municipio), Municipio %in% unique(muni.data$Municipio)) %>%
    assertr::verify(unique(.$Medida) ==
                      c("Población", "Confirmados PCR", "Confirmados PCR 14 días",
                        "Fallecidos", "Curados", "Confirmados total", "Confirmado PCR"
    )) %>%
    mutate(Medida = ifelse(Medida == "Confirmado PCR", "Confirmados PCR", Medida)) %>%
    #mutate(Medida = ifelse(Medida == "Defunciones total", "Defunciones", Medida)) %>%
    dplyr::filter(Medida == "Confirmados PCR" | Medida == "Confirmados total" | Medida == "Fallecidos") %>%
    tidyr::pivot_wider(names_from = "Medida", values_from = "Valor") %>%
    rename(ConfirmadosPCR = `Confirmados PCR`,
           ConfirmadosTotal = `Confirmados total`,
           Defunciones = Fallecidos) %>%
    mutate(Fecha = fecha.munis) %>%
    right_join(munis, by = "Municipio") %>%
    dplyr::select(Fecha, Provincia, Distrito, Municipio,
                  ConfirmadosPCR, ConfirmadosTotal, Defunciones)


  muni.dia %>%
    assertr::verify(all.equal(names(muni.dia), names(muni.data)))

  muni.data <- dplyr::bind_rows(muni.data, muni.dia) %>%
    arrange(Fecha, Provincia, Distrito, Municipio) %>%
    readr::write_csv(path = "datos/municipios.csv")

}


## Render

rmarkdown::render("evolucion-coronavirus-andalucia.Rmd")


