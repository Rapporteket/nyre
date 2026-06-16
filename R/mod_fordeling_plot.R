#' Shiny module providing GUI and server logic for the plot tab
#'
#' @param id Character string module namespace
#' @return An shiny app ui object
#' @export

mod_fordeling_plot_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::sidebarLayout(
      # Inputs: select variables to plot
      shiny::sidebarPanel(
        width = 4,
        # Select variable for x-axis
        shiny::selectInput( # First select
          inputId = ns("x_var"),
          label = "Variabel:",
          choices = c(
            "Kjoenn" = "preOp_gender",
            "BMI" = "preOp_calcBMI_cat",
            "Mallampati score" = "preOp_mallampati",
            "Preoperativ smerte" = "preOp_pain",
            "Behandling" = "treat",
            "Stoerrelse inngrep" = "intraOp_surgerySize",
            "Hosting etter ekstubasjon" = "extubation_cough",
            "Hosting 30 min etter oppvaakning" = "pacu30min_cough",
            "Halssmerter 30 min etter oppvaakning" = "pacu30min_throatPain",
            "Halssmerter ved sveging 30 min etter opppvaakning" = "pacu30min_swallowPain",
            "Hosting 90 min etter oppvaakning" = "pacu90min_cough",
            "Halssmerter 90 min etter oppvaakning" = "pacu90min_throatPain",
            "Hosting 4 timer etter oppvaakning" = "postOp4hour_cough",
            "Halssmerter 4 timer etter oppvaakning" = "postOp4hour_throatPain",
            "Hosting morgen etter operasjon" = "pod1am_cough",
            "Halssmerter morgen etter operasjon" = "pod1am_throatPain"
          ),
          selected = "preOp_pain"
        ),
        # Filtrere på alder
        shiny::sliderInput( # fourth select
          inputId = ns("alder_var"),
          label = "Aldersintervall:",
          min = 0,
          max = 100,
          value = c(10, 100),
          dragRange = TRUE
        ),

        # Filtrere på Røyking
        shiny::radioButtons(
          inputId = ns("roeking"),
          label = "Røyker?",
          choices = c(
            "Nå" = "Naa",
            "Før" = "Foer",
            "Aldri" = "Aldri",
            "Alle valg" = "alle_valg"
          ),
          selected = "alle_valg"
        ),

        # Sammenligne grupper
        shiny::radioButtons(
          inputId = ns("sammenligne_grupper"),
          label = "Sammenligne fordeling mellom grupper?",
          choices = c("Ja", "Nei"),
          selected = "Nei"
        ),

        shiny::conditionalPanel(
          condition = "input.sammenligne_grupper == 'Ja'",
          shiny::selectInput(
            inputId = ns("var_sammenligning"),
            label = "Sammenligne grupper",
            choices = c(
              "Kjoenn" = "preOp_gender",
              "Behandling" = "treat",
              "ASA-grad" = "preOp_asa",
              "Kirurgi stoerrelse" = "intraOp_surgerySize",
              "BMI" = "preOp_calcBMI_cat"
            ),
            selected = "preOp_gender"
          ),
          ns = shiny::NS(id)
        )
      ),

      shiny::mainPanel(
        shiny::tabsetPanel(
          id = shiny::NS(id, "tab"),
          shiny::tabPanel(
            "Figur", value = "Fig",
            shiny::plotOutput(outputId = shiny::NS(id, "fordeling_plot")),
            shiny::downloadButton(
              shiny::NS(id, "nedlastning_fordeling_plot"),
              "Last ned figur"
            )
          ),
          shiny::tabPanel(
            "Tabell", value = "Tabl",
            DT::DTOutput(outputId = shiny::NS(id, "fordeling_tabell")),
            shiny::downloadButton(
              shiny::NS(id, "nedlastning_fordeling_tabell"),
              "Last ned tabell"
            )
          )
        )
      )
    )
  )
}

#' @param id Character string module namespace
#' @param data Data frame containing the data to be plotted.
#'
#'@title Server fordeling
#'
#'@export

mod_fordeling_plot_server <- function(id, data) {
  shiny::moduleServer(
    id,
    function(input, output, session) {

      data <- forbered_data_fordeling(data)

      data_reactive <- shiny::reactive({
        data <- rapRegTemplate::utvalg_fordeling(
          data,
          input$alder_var[1],
          input$alder_var[2],
          input$roeking
        )
      })

      tabell_reactive <- shiny::reactive({
        shiny::req(c(input$var_sammenligning))
        rapRegTemplate::lag_fordeling_tabell(
          data_reactive(),
          input$x_var,
          input$sammenligne_grupper,
          input$var_sammenligning
        )
      })

      plot_reactive <- shiny::reactive({
        shiny::req(c(input$var_sammenligning))
        rapRegTemplate::lag_fordeling_plot(
          data_reactive(),
          input$x_var,
          input$sammenligne_grupper,
          input$var_sammenligning
        )
      })

      output$fordeling_plot <- shiny::renderPlot({
        plot_reactive()
      })

      output$fordeling_tabell <- DT::renderDT({
        tabell_reactive()
      })

      # Lag nedlastning plot
      output$nedlastning_fordeling_plot <-  shiny::downloadHandler(
        filename = function() {
          paste("plot_fordeling", Sys.Date(), ".pdf", sep = "")
        },
        content = function(file) {
          pdf(file, onefile = TRUE, width = 15, height = 9)
          plot(plot_reactive())
          dev.off()
        }
      )

      # Lag nedlastning tabell
      output$nedlastning_fordeling_tabell <-  shiny::downloadHandler(
        filename = function() {
          paste("tabell_fordeling", Sys.Date(), ".pdf", sep = "")
        },
        content = function(file) {
          pdf(file, onefile = TRUE, width = 15, height = 9)
          plot(tabell_reactive())
          dev.off()
        }
      )

    }
  )
}
