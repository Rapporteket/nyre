#' Server logic for the rapRegTemplate app
#'
#' @param input shiny input object
#' @param output shiny output object
#' @param session shiny session object
#'
#' @return A shiny app server object
#' @export

app_server <- function(input, output, session) {

  # Brukerinformasjon i menylinja (navbar)
  output$appUserName <- shiny::renderText(
    paste(rapbase::getUserFullName(session),
          rapbase::getUserRole(session), sep = ", ")
  )
  output$appOrgName <- shiny::renderText(rapbase::getUserReshId(session))
  userInfo <-
    rapbase::howWeDealWithPersonalData(session, callerPkg = "rapRegTemplate")

  shiny::observeEvent(input$userInfo, {
    shinyalert::shinyalert("Dette vet Rapporteket om deg:", userInfo,
                           type = "", imageUrl = "rap/logo.svg",
                           closeOnEsc = TRUE, closeOnClickOutside = TRUE,
                           html = TRUE, confirmButtonText = rapbase::noOptOutOk())
  })

  veiledning_server("veiledning")
  plots_server("plots")
  samlerapport_server("samlerapport")
  abonnement_server("abonnement")
  utsending_server("utsending")
}
