
## Especificar fecha de datos
fecha.munis <- as.Date("2021-12-27")

fecha.edad <- as.Date("2021-12-26")



library(dplyr)

#### Datos municipios #####

muni.data <- readr::read_csv("datos/municipios.csv",
                             col_types = "Dcccddddd",
                             guess_max = 50000)

munis <- readr::read_csv("datos/muni_prov_dist.csv")


if (!fecha.munis %in% as.Date(muni.data$Fecha)) {

  ## Using big CSV from https://www.juntadeandalucia.es/institutodeestadisticaycartografia/badea/operaciones/consulta/anual/42798?CodOper=b3_2314&codConsulta=42798
  muni.dia <- readr::read_csv2("datos/municipios.dia/Municipios_todos_datoshoy.csv", col_types = "ccd_")

  ## Using CSV by province
  # munis.dia <- list.files("datos/municipios.dia/", pattern = ".csv", full.names = TRUE)
  # muni.dia <- purrr::map_df(munis.dia, readr::read_csv2, col_types = "ccd_")

  muni.dia <- muni.dia %>%
    rename(Municipio = `Lugar de residencia`) %>%
    #dplyr::select(-X4) %>%
    dplyr::filter(!is.na(Municipio), Municipio %in% unique(muni.data$Municipio)) %>%
    dplyr::filter(!is.na(Medida)) %>%
    dplyr::filter(Medida != "Población") %>%
    dplyr::filter(Medida != "Tasa PDIA") %>%
    dplyr::filter(Medida != "Confirmados PDIA 7 días") %>%
    dplyr::filter(Medida != "Tasa PDIA 7 dias") %>%
    dplyr::filter(Medida != "Tasa total confirmados") %>%
    dplyr::filter(Medida != "Curados") %>%
    mutate(Medida = ifelse(Medida == "Tasa PDIA 14 dias", "Tasa PDIA 14 días", Medida)) %>%
    assertr::verify(unique(.$Medida) ==
                      c("Confirmados PDIA",
                        "Confirmados PDIA 14 días",
                        "Tasa PDIA 14 días",
                        "Total Confirmados",
                        "Fallecidos")) %>%
    mutate(Medida = ifelse(Medida == "Tasa PDIA 14 días", "Conf14d_100.000hab", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Confirmados PDIA", "Confirmados.PCR.TA", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Confirmados PDIA 14 días", "Confirmados.PCR.TA.14d", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Total Confirmados", "ConfirmadosTotal", Medida)) %>%
    mutate(Medida = ifelse(Medida == "Fallecidos", "Defunciones", Medida)) %>%
    dplyr::filter(Medida == "Confirmados.PCR.TA" | Medida == "Confirmados.PCR.TA.14d" |
                    Medida == "Conf14d_100.000hab" |
                    Medida == "ConfirmadosTotal" | Medida == "Defunciones") %>%
    mutate(rownumber = 1:nrow(.)) %>%
    group_by(Municipio) %>%
    arrange(rownumber) %>%
    slice_tail(n = 5) %>%
    ungroup() %>%
    select(-rownumber) %>%
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


#### Descargar datos CNE ####

url.iscii.edad <- "https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv"
if (!httr::http_error(url.iscii.edad)) {
  download.file("https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv",
              destfile = "datos/casos_hosp_uci_def_sexo_edad_provres.csv")
}



#### Descarga datos Ocupación Hospitalaria Minist. Sanidad
fecha.informe <- Sys.Date()
url.camas.minist <- paste0("https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov/documentos/Datos_Capacidad_Asistencial_Historico_",
                           format(fecha.informe, "%d%m%Y"), ".csv")
while (httr::http_error(url.camas.minist)) {
  fecha.informe <- fecha.informe - 1
  url.camas.minist <- paste0("https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov/documentos/Datos_Capacidad_Asistencial_Historico_",
                             format(fecha.informe, "%d%m%Y"), ".csv")
}
download.file(url.camas.minist, destfile = "datos/datos_camas_ministerio.csv")



#### Datos Minist Nº pruebas

fecha.test <- Sys.Date()
url.test.minist <- paste0("https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov/documentos/Datos_Pruebas_Realizadas_Historico_",
                           format(fecha.test, "%d%m%Y"), ".csv")
while (httr::http_error(url.test.minist)) {
  fecha.test <- fecha.test - 1
  url.test.minist <- paste0("https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov/documentos/Datos_Pruebas_Realizadas_Historico_",
                             format(fecha.test, "%d%m%Y"), ".csv")
}
download.file(url.test.minist, destfile = "datos/datos_test_ministerio.csv")


## Render

rmarkdown::render("evolucion-coronavirus-andalucia.Rmd")


