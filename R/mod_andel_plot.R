.private <- new.env(parent = emptyenv())
.private$andVarChoices <- c(
  "Tung (>= 4000g)"        = "heavy",
  "Langt nebb (>= 45mm)"   = "long_bill",
  "Dype nebb (>= 18mm)"    = "deep_bill",
  "Lang flipper (>= 200mm)" = "long_flipper",
  "Hann"                   = "male"
)

.private$andBinChoices <- c(
  "Art"    = "species",
  "Øy"     = "island",
  "Kjønn"  = "sex",
  "År"     = "year"
)

#' Shiny module providing GUI and server logic for the Andeler tab
#'
#' @param id Character string module namespace
#' @return An shiny app ui object
#' @export

mod_andeler_ui <- function(id) {
  ns <- shiny::NS(id)



  shiny::tagList(

    "Andel basert på variabel og grenser",
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 3,
        shiny::selectInput(
          inputId = ns("varS"),
          label = "Variabel:",
          choices = .private$andVarChoices
        ),
        shiny::selectInput(
          inputId = ns("binsS"),
          label = "Sortert etter:",
          choices = .private$andBinChoices
        ),
        shiny::sliderInput(
          inputId = ns("limitS"),
          label = "Inklusjonskriterie (>n):",
          min = 0,
          max = 100,
          value = 1
        ),
        shiny::downloadButton(
          outputId = ns("downloadandelPlot"),
          label = "Last ned!"
        )
      ),
      shiny::mainPanel(
        shiny::plotOutput(outputId = shiny::NS(id, "andelPlot"))
      )
    )
  )
}

#' Server logic for andel plot
#'
#' @param id Character string module namespace
#' @param data Data frame containing the data to be plotted.
#'
#' @return A Shiny app server object
#' @export

mod_andeler_server <- function(id, data) {
  shiny::moduleServer(
    id,
    function(input, output, session) {

      data_reactive <- shiny::reactive({
        data
      })

      plotReactive <- shiny::reactive({
        data <- as.data.frame(data_reactive())
        var <- input$varS
        bins <- input$binsS
        limit <- input$limitS

        var_label  <- names(.private$andVarChoices)[.private$andVarChoices == input$varS]
        bins_label <- names(.private$andBinChoices)[.private$andBinChoices == input$binsS]

        tittel <- paste(
          "Andel", var_label,
          "etter", bins_label,
          "med mer enn", input$limitS, "registreringer"
        )

        rapRegTemplate::PlotAndelerGrVar(
          RegData = data,
          Variabel = data[[var]],
          grVar = bins,
          Ngrense = limit,
          tittel = tittel,
          kvalIndGrenser = attr(data, "kvalIndGrenser")[[var]],
          bestKvalInd = "høy"
        )
      })

      output$andelPlot <- shiny::renderPlot({
        plotReactive()
      })

      output$downloadandelPlot <-  shiny::downloadHandler(
        filename = function() {
          paste("plot_andeler", Sys.Date(), ".pdf", sep = "")
        },
        content = function(file) {
          pdf(file, onefile = TRUE, width = 15, height = 9)
          plot(plotReactive())
          dev.off()
        }
      )


    }
  )
}
