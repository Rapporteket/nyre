#' Shiny module providing GUI and server logic for the report tab
#'
#' @param id Character string module namespace
NULL

samlerapport_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::tabPanel(
    "Fordeling av mpg",
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 3,
        shiny::selectInput(
          inputId = ns("varS"),
          label = "Variabel:",
          c("mpg", "disp", "hp", "drat", "wt", "qsec")
        ),
        shiny::sliderInput(
          inputId = ns("binsS"),
          label = "Antall grupper:",
          min = 1,
          max = 10,
          value = 5
        ),
        shiny::selectInput(
          inputId = ns("formatS"),
          label = "Velg format for nedlasting:",
          choices = list(PDF = "pdf", HTML = "html")
        ),
        shiny::downloadButton(
          outputId = ns("downloadSamlerapport"),
          label = "Last ned!"
        )
      ),
      shiny::mainPanel(
        shiny::uiOutput(ns("samlerapport"))
      )
    )
  )
}

samlerapport_server <- function(id) {
  shiny::moduleServer(
    id,
    function(input, output, session) {

      # Samlerapport
      ## vis
      output$samlerapport <- shiny::renderUI({
        rapbase::renderRmd(
          system.file("samlerapport.Rmd", package = "rapRegTemplate"),
          outputType = "html_fragment",
          params = list(type = "html",
                        var = input$varS,
                        bins = input$binsS)
        )
      })

      ## last ned
      output$downloadSamlerapport <- shiny::downloadHandler(
        filename = function() {
          basename(tempfile(pattern = "rapRegTemplateSamlerapport",
                            fileext = paste0(".", input$formatS)))
        },
        content = function(file) {
          srcFile <-
            normalizePath(system.file("samlerapport.Rmd", package = "rapRegTemplate"))
          fn <- rapbase::renderRmd(srcFile, outputType = input$formatS,
                                   params = list(type = input$formatS,
                                                 var = input$varS,
                                                 bins = input$binsS))
          file.rename(fn, file)
        }
      )
    }
  )
}
