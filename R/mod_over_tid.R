#' Shiny module providing GUI and server logic for the plot tab
#'
#' @param id Character string module namespace
#' @return An shiny app ui object
#' @export

mod_over_tid_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::sidebarLayout(

      shiny::sidebarPanel(
        width = 4,

        shiny::selectInput( # valg en
          inputId = ns("var"),
          label = "Velg variabel",
          choices = c(
            "Meslinger rate pr. 1000000" = "measles_incidence_rate_per_1000000_total_population",
            "Røde hunder rate pr. 1000000" = "rubella_incidence_rate_per_1000000_total_population",
            "Forkastede prøver meslinger og røde hunder rate pr. 1000000" =
              "discarded_non_measles_rubella_cases_per_100000_total_population"
          ),
          selected = "Meslinger rate pr. 1000000"
        ),

        shiny::selectInput(# valg to
          inputId = ns("region"),
          label = "Velg region",
          choices = c(
            "Alle regioner samlet" = "Alle",
            "Alle regioner delt" = "Alle_delt",
            "Region Afrika (AFRO)" = "AFRO",
            "Region Amerika (AMRO" = "AMRO",
            "Region Sør-Øst Asia (SEARO)" = "SEARO",
            "Region Europa (EURO)" = "EURO",
            "Region østlige Middelhavet (EMRO)" = "EMRO",
            "Region vestlige Stillehavet (WPRO)" = "WPRO"
          ),
          selected = "AFRO"
        )
      ),

      shiny::mainPanel(
        shiny::tabsetPanel(
          id = ns("tab"),
          shiny::tabPanel(
            "Figur",
            value = "Fig",
            shiny::plotOutput(outputId = ns("over_tid_plot")),
            shiny::downloadButton(
              ns("nedlastning_over_tid_plot"),
              "Last ned figur"
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

mod_over_tid_server <- function(id, data) {
  shiny::moduleServer(
    id,
    function(input, output, session) {

      data_over_tid_reactive <- shiny::reactive({
        rapRegTemplate::over_tid_utvalg(data, input$var, input$region)
      })

      plot_over_tid_reactive <- shiny::reactive({
        rapRegTemplate::over_tid_plot(data_over_tid_reactive(), input$region)
      })

      output$over_tid_plot <- shiny::renderPlot({
        plot_over_tid_reactive()
      })

      # Lag nedlastning
      output$nedlastning_over_tid_plot <-  shiny::downloadHandler(
        filename = function() {
          paste("plot_over_tid", Sys.Date(), ".pdf", sep = "")
        },
        content = function(file) {
          pdf(file, onefile = TRUE, width = 15, height = 9)
          plot(plot_over_tid_reactive())
          dev.off()
        }
      )
    }
  )
}
