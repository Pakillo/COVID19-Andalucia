
library(shiny)
library(dplyr)
library(ggplot2)
#library(plotly)
library(DT)


#### FUNCTIONS ####

select_data <- function(df, provincia, municipio, start, end) {

    df %>%
        filter(Provincia == provincia, Municipio == municipio) %>%
        dplyr::select(-Provincia, -Distrito, -Municipio, -ConfirmadosPCR14d) %>%
        filter(Fecha >= start, Fecha <= end)

}

make_plot <- function(df, municipio) {

    df %>%
        #dplyr::select(-Provincia, -Distrito, -Municipio, -ConfirmadosPCR14d) %>%
        #mutate_at(4:6, function(x) {x - lag(x)}) %>%  # daily numbers rather than cumulative?
        tidyr::pivot_longer(cols = `ConfirmadosPCR`:Defunciones,
                            names_to = "vble", values_to = "valor") %>%
        ggplot() +
        facet_wrap(~vble, ncol = 1, scales = "free_y") +
        geom_line(aes(Fecha, valor, colour = vble), lwd = 2) +
        scale_colour_manual(values = c("#ff7f00", "#377eb8", "grey40")) +
        #scale_y_continuous(limits = c(0, NA)) +
        labs(x = "", y = "Nº personas\n", title = municipio,
             caption = "https://tiny.cc/COVID19-Andalucia") +
        theme_minimal(base_size = 12) +
        theme(legend.position = "none",
              plot.title = element_text(size = 15),
              plot.caption = element_text(size = 8, face = "italic", colour = "grey60"),
              strip.text = element_text(size = 12))
}


#### LOAD DATA ####

datos.muni <- readr::read_csv("https://raw.githubusercontent.com/Pakillo/COVID19-Andalucia/master/datos/municipios.csv", guess_max = 50000)

#datos.muni <- readr::read_csv("../datos/municipios.csv", guess_max = 10000)

provs <- c("Almería", "Cádiz", "Córdoba", "Granada",
           "Huelva", "Jaén", "Málaga", "Sevilla")



##### Define UI for application ####

ui <- pageWithSidebar(
    headerPanel('COVID-19 en Andalucía: datos por municipio'),
    sidebarPanel(
        selectInput('prov', 'Provincia', provs, selected = "Córdoba"),
        uiOutput('muni'),
        dateRangeInput('dateRange',
                       label = 'Periodo:',
                       start = "2020-05-01", end = Sys.Date() - 1,
                       min = "2020-05-01", max = Sys.Date() - 1,
                       separator = " - ")
    ),
    mainPanel(
        tabsetPanel(
            tabPanel("Gráfica", plotOutput('plot1')),
            tabPanel("Tabla", DT::dataTableOutput('table1'))
        )
    )
)





##### Define server logic ####

server <- function(input, output, session) {

    # Municipio choices based on selected Provincia
    output$muni <- renderUI({
        selectInput('muni', 'Municipio',
                    choices = sort(unique(datos.muni$Municipio[datos.muni$Provincia == input$prov])),
                    selected = "Montilla")
    })


    selectedData <- reactive({
        select_data(datos.muni,
                    provincia = input$prov,
                    municipio = input$muni,
                    start = input$dateRange[1],
                    end = input$dateRange[2])})

    # grafica
    output$plot1 <- renderPlot({make_plot(selectedData(), municipio = input$muni)})


    # tabla datos
    output$table1 <- DT::renderDT(
        datatable(arrange(selectedData(), desc(Fecha)),
                  rownames = FALSE))

}



# Run the application
shinyApp(ui = ui, server = server)
