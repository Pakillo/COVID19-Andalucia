
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(DT)

datos.muni <- readr::read_csv("https://raw.githubusercontent.com/Pakillo/COVID19-Andalucia/master/datos/municipios.csv", guess_max = 10000)

#datos.muni <- readr::read_csv("../datos/municipios.csv", guess_max = 10000)

provs <- c("Almería", "Cádiz", "Córdoba", "Granada",
           "Huelva", "Jaén", "Málaga", "Sevilla")

# Define UI for application
ui <- pageWithSidebar(
    headerPanel('COVID-19 en Andalucía: datos por municipio'),
    sidebarPanel(
        selectInput('prov', 'Provincia', provs, selected = "Córdoba"),
        uiOutput('muni')
    ),
    mainPanel(
        tabsetPanel(
            tabPanel("Gráfica", plotlyOutput('plot1')),
            tabPanel("Tabla", DT::dataTableOutput('table1'))
        )
    )
)





# Define server logic
server <- function(input, output, session) {

    # Municipio choices based on selected Provincia
    output$muni <- renderUI({
        selectInput('muni', 'Municipio',
                    choices = sort(unique(datos.muni$Municipio[datos.muni$Provincia == input$prov])), selected = "Montilla")
    })


    selectedData <- reactive({
        datos.muni %>%
        filter(Provincia == input$prov, Municipio == input$muni) %>%
            dplyr::select(-Distrito)
    })




    # grafica
    output$plot1 <- renderPlotly({

        plotly::ggplotly(
            selectedData() %>%
                rename(`Confirmados PCR` = ConfirmadosPCR,
                       `Confirmados Total (PCR + test)` = ConfirmadosTotal) %>%
                #mutate_at(4:6, function(x) {x - lag(x)}) %>%  # daily numbers rather than cumulative?
                tidyr::pivot_longer(cols = `Confirmados PCR`:Defunciones,
                                    names_to = "vble", values_to = "valor") %>%
                ggplot() +
                facet_wrap(~vble, ncol = 1, scales = "free_y") +
                geom_col(aes(Fecha, valor, fill = vble), lwd = 2) +
                scale_fill_manual(values = c("#ff7f00", "#377eb8", "grey40")) +
                scale_y_continuous(limits = c(0, NA)) +
                labs(x = "", y = "Nº personas\n", title = input$muni,
                     caption = "https://tiny.cc/COVID19-Andalucia") +
                theme_minimal(base_size = 12) +
                theme(legend.position = "none",
                      plot.title = element_text(size = 15),
                      plot.caption = element_text(size = 8, face = "italic", colour = "grey60"),
                      strip.text = element_text(size = 12)))
    })



    # tabla datos
    output$table1 <- DT::renderDT(
        datatable(selectedData(), rownames = FALSE))

}



# Run the application
shinyApp(ui = ui, server = server)
