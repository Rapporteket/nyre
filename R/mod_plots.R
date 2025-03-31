#' Shiny module providing GUI and server logic for the plot tab
#'
#' @param id Character string module namespace
NULL

plots_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::sidebarLayout(
    shiny::sidebarPanel(
      width = 3,
      shiny::selectInput(
        inputId = ns("var"),
        label = "Variabel:",
        c("mpg", "disp", "hp", "drat", "wt", "qsec")
      ),
      shiny::sliderInput(
        inputId = ns("bins"),
        label = "Antall grupper:",
        min = 1,
        max = 10,
        value = 5
      )
    ),
    shiny::mainPanel(
      shiny::tabsetPanel(
        shiny::tabPanel(ns("Figur"), shiny::plotOutput(ns("distPlot"))),
        shiny::tabPanel(ns("Tabell"), shiny::tableOutput(ns("distTable")))
      )
    )
  )
}

plots_server <- function(id) {
  shiny::moduleServer(
    id,
    function(input, output, session) {

      # Last inn data
      regData <- getFakeRegData()

      # Figur og tabell
      # Figur
      output$distPlot <- shiny::renderPlot({
        makeHist(df = regData, var = input$var, bins = input$bins)
      })

      # Tabell
      output$distTable <- shiny::renderTable({
        makeHist(df = regData, var = input$var, bins = input$bins,
                 makeTable = TRUE)
      })
    }
  )
}
