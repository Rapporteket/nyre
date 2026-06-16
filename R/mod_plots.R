#' Shiny module providing GUI and server logic for the plot tab
#'
#' @param id Character string module namespace
#' @return An shiny app ui object

plots_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::sidebarLayout(
    shiny::sidebarPanel(
      width = 3,
      shiny::uiOutput(shiny::NS(id, "select_x")),
      shiny::uiOutput(shiny::NS(id, "select_y"))
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
        makeHist(df = regData, var = input$y, x = input$x)
      })

      # Tabell
      output$distTable <- shiny::renderTable({
        makeHist(df = regData, var = input$var,
                 makeTable = TRUE)
      })
      output$select_x <- shiny::renderUI({
        shiny::selectInput(
          inputId = shiny::NS(id, "x"),
          label = "Variabel:",
          choices = names(regData)[1:4]
        )
      })
      output$select_y <- shiny::renderUI({
        shiny::selectInput(
          inputId = shiny::NS(id, "y"),
          label = "Variabel:",
          choices = names(regData)[-1:-4]
        )
      })
    }
  )
}
