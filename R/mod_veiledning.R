#' Shiny module providing GUI and server logic for the intro tab
#'
#' @param id Character string module namespace
#' @return An shiny app ui object
#' @export

info_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::mainPanel(
    width = 12,
    shiny::h2("Brukerinformasjon"),
    shiny::uiOutput(ns("user_info"), inline = TRUE),
    shiny::hr(),
    shiny::h2("Rendering av Rmarkdown-fil"),
    shiny::uiOutput(ns("info"), inline = TRUE)
  )
}

#' Server logic
#'
#' @param id Character string module namespace
#' @param user Shiny user object, som defineres av shiny-modulen
#' rapbase::navbarWidgetServer2. Denne inneholder informasjon om pålogget
#' bruker, og kan brukes til å tilpasse innholdet i appen basert på brukerens
#' rolle eller organisasjon.
#'
#' @return A shiny app server object
#' @export

info_server <- function(id, user) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      output$user_info <- shiny::renderUI({
        shiny::tagList(
          shiny::p(
            "Informasjon om pålogget bruker fra variabelen ",
            shiny::code("user"),
            ", som defineres av shiny-modulen",
            shiny::code("rapbase::navbarWidgetServer2"),
            "."
          ),
          shiny::p(
            "Brukernavn (user$name(), hentet fra miljøvariabelen SHINYPROXY_USERNAME): ",
            shiny::strong(user$name()),
            shiny::br(),
            "Navn (user$fullName(), hentet fra miljøvariabelen FALK_USER_FULLNAME): ",
            shiny::strong(user$fullName()),
            shiny::br(),
            "Epost (user$email(), hentet fra miljøvariabelen FALK_USER_EMAIL): ",
            shiny::strong(user$email()),
            shiny::br(),
            "Telefonnummer (user$phone(), hentet fra miljøvariabelen FALK_USER_PHONE): ",
            shiny::strong(user$phone()),
            shiny::br(),
            "ReshID (user$org(), valgt i meny): ",
            shiny::strong(user$org()),
            shiny::br(),
            "Enhetsnavn (user$orgName(), hvis mapping mellom ReshID og sykehusnavn er ok): ",
            shiny::strong(user$orgName()),
            shiny::br(),
            "Rolle (user$role(), valgt i meny): ",
            shiny::strong(user$role())
          )
        )
      })

      # Info
      output$info <- shiny::renderUI({
        rapbase::renderRmd(
          system.file("info.Rmd", package = "rapRegTemplate"),
          outputType = "html_fragment"
        )
      })
    }
  )
}
