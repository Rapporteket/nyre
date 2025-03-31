#' Shiny module providing GUI and server logic for the intro tab
#'
#' @param id Character string module namespace
NULL

veiledning_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::mainPanel(
    width = 12,
    shiny::htmlOutput(ns("veiledning"), inline = TRUE),
    rapbase::appNavbarUserWidget(
      user = shiny::uiOutput(ns("appUserName")),
      organization = shiny::uiOutput(ns("appOrgName")),
      addUserInfo = TRUE
    )
  )
}

veiledning_server <- function(id) {
  shiny::moduleServer(
    id,
    function(input, output, session) {

      # Veiledning
      output$veiledning <- shiny::renderUI({
        rapbase::renderRmd(
          system.file("veiledning.Rmd", package = "rapRegTemplate"),
          outputType = "html_fragment"
        )
      })
    }
  )
}
