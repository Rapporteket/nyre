#' Run the Shiny Application
#'
#' @param browser Open app in browser window
#' @param logAsJson Log in json-format
#'
#' @return An object representing the app
#' @export

run_app <- function(browser = FALSE, logAsJson = FALSE) {

  if (logAsJson) {
    rapbase::loggerSetup()
  }
  if (browser) {
    options(shiny.launch.browser = TRUE)
  }
  if (!capabilities()["cairo"]) {
    knitr::opts_chunk$set(dev = "svglite") # To make it work without cairo.
  }
  shiny::shinyApp(
    ui = app_ui,
    server = app_server
  )
}
