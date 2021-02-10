
library(dplyr)

## Especificar fecha de datos
fecha.munis <- as.Date("2021-02-04")

fecha.edad <- as.Date("2021-02-08")




## Descargar datos IECA

# Acumulados
download.file("https://www.juntadeandalucia.es/institutodeestadisticaycartografia/badea/stpivot/stpivot/Print?cube=d8aa0b74-f3ed-4db7-adef-c45fd2680f2e&type=3&foto=si&ejecutaDesde=&codConsulta=38228&consTipoVisua=JP",
              destfile = "datos/acumulados.csv", mode = "wb")

# Provincias
download.file("https://www.juntadeandalucia.es/institutodeestadisticaycartografia/badea/stpivot/stpivot/Print?cube=1fe435eb-a064-4f01-8dcf-cfe132996c14&type=3&foto=si&ejecutaDesde=&codConsulta=39409&consTipoVisua=JP",
              destfile = "datos_provincias_raw.csv", mode = "wb")

# Edad Confirmados
download.file("https://www.juntadeandalucia.es/institutodeestadisticaycartografia/badea/stpivot/stpivot/Print?cube=8f2cc994-051e-415f-b2f4-50d6fc8c9a3d&type=3&foto=si&ejecutaDesde=&codConsulta=41135&consTipoVisua=JP",
              destfile = "datos/confPCR_edad_fecha.csv", mode = "wb")

# Municipios
# Almeria
# Cádiz
# Córdoba
# Granada
# Huelva
# Jaén
# Málaga
# Sevilla


# Piramides
# Casos
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/badea/stpivot/stpivot/Print?cube=91072e3b-fc90-4f37-9d95-91f78304f63f&type=3&codConsulta=39356&consTipoVisua=TJP",
              destfile = "datos/edad.sexo/datos_casos_edad_sexo.csv", mode = "wb")

# Hosp
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/badea/stpivot/stpivot/Print?cube=604fd587-141a-4b2c-9a93-32d1f9bd5ca0&type=3&foto=si&ejecutaDesde=&codConsulta=39351&consTipoVisua=JP",
              destfile = "datos/edad.sexo/datos_hosp_edad_sexo.csv", mode = "wb")

# UCI
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/badea/stpivot/stpivot/Print?cube=640a40a8-bdf3-4fce-a6ea-051d42e36973&type=3&foto=si&ejecutaDesde=&codConsulta=39355&consTipoVisua=JP",
              destfile = "datos/edad.sexo/datos_uci_edad_sexo.csv", mode = "wb")

# Defunciones
download.file(url = "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/badea/stpivot/stpivot/Print?cube=ee25daa4-2a05-4960-adca-fc451a8d15cc&type=3&foto=si&ejecutaDesde=&codConsulta=39354&consTipoVisua=JP",
              destfile = "datos/edad.sexo/datos_def_edad_sexo.csv", mode = "wb")





#### Datos municipios #####

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


#### Descargar datos CNE ####

download.file("https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv",
              destfile = "datos/casos_hosp_uci_def_sexo_edad_provres.csv")


## Render

rmarkdown::render("evolucion-coronavirus-andalucia.Rmd")


