#' Server logic for the rapRegTemplate app
#'
#' @param input shiny input object
#' @param output shiny output object
#' @param session shiny session object
#'
#' @return A shiny app server object
#' @export

app_server <- function(input, output, session) {

  # data.frame som mapper ReshID og sykehusnavn
  map_orgname <- data.frame(
    UnitId = c(111, 222, 333),
    orgname = c("Sykehus 1", "Sykehus 2", "Sykehus 3")
  )
  user <- rapbase::navbarWidgetServer2(
    "navbar-widget",
    orgName = "pilot",
    map_orgname = map_orgname,
    caller = "rapRegTemplate"
  )

  meslinger_data <- getFakeRegData()
  penguinData <- getFakeRegData2()

  data_licorice_gargle <- licorice_gargle

  info_server("info", user = user)
  samlerapport_server("samlerapport")
  mod_fordeling_plot_server("fordeling", data = data_licorice_gargle)
  mod_over_tid_server("over_tid", data = meslinger_data)
  mod_andeler_server("andeler", data = penguinData)

  #################
  # Subscriptions #
  #################

  subParamNames <- shiny::reactive(c("reshID"))
  subParamValues <- shiny::reactive(user$org())

  rapbase::autoReportServer(
    id = "subscription",
    registryName = "rapRegTemplate",
    type = "subscription",
    paramNames = subParamNames,
    paramValues = subParamValues,
    reports = list(
      `Automatisk samlerapport1` = list(
        synopsis = "
        Automatisk samlerapport1 som inneholder spennende statistikk
        om pasienter og operasjoner",
        fun = "samlerapport1Fun",
        paramNames = c("p1", "p2", "reshID"),
        paramValues = c("Alder", 1, 999999)
      ),
      `Automatisk samlerapport2` = list(
        synopsis = "Automatisk samlerapport2 som inneholder
        enda mer spennende statistikk
        om pasienter og operasjoner, i tillegg til BMI",
        fun = "samlerapport2Fun",
        paramNames = c("p1", "p2", "reshID"),
        paramValues = c("BMI", 1, 999999)
      )
    ),
    freq = "quarter",
    user = user
  )

  ################
  # SC user tabs #
  ################

  shiny::observeEvent(
    shiny::req(user$role()), {
      if (user$role() != "SC") {
        message("Removing dispatchment tab for user with role ", user$role())
        shiny::removeTab("tabs", target = "Utsending")
        message("Removing export tab for user with role ", user$role())
        shiny::removeTab("tabs", target = "Eksport")
      } else {
        message("Adding dispatchment tab for user with role ", user$role())
        shiny::appendTab(
          "tabs",
          shiny::tabPanel(
            "Utsending",
            shiny::sidebarLayout(
              shiny::sidebarPanel(
                rapbase::autoReportFormatInput("dispatchment"),
                rapbase::autoReportOrgInput("dispatchment"),
                rapbase::autoReportInput("dispatchment")
              ),
              shiny::mainPanel(
                rapbase::autoReportUI("dispatchment")
              )
            )
          )
        )
        message("Adding export tab for user with role ", user$role())
        shiny::appendTab(
          "tabs",
          shiny::tabPanel(
            "Eksport",
            shiny::sidebarLayout(
              shiny::sidebarPanel(
                rapbase::exportUCInput("export")
              ),
              shiny::mainPanel(
                rapbase::exportGuideUI("exportGuide")
              )
            )
          )
        )
      }
    }
  )


  #################
  # Dispatchments #
  #################

  orgs <- list(
    OrgOne = 100082,
    OrgTwo = 102966
  )

  org <- rapbase::autoReportOrgServer("dispatchment", orgs)

  disParamNames <- shiny::reactive(c("reshID"))
  disParamValues <- shiny::reactive(c(org$value()))

  rapbase::autoReportServer(
    id = "dispatchment",
    registryName = "rapRegTemplate",
    type = "dispatchment",
    org = org$value,
    paramNames = disParamNames,
    paramValues = disParamValues,
    reports = list(
      `Automatisk samlerapport1` = list(
        synopsis = "
        Automatisk samlerapport1 som inneholder spennende statistikk
        om pasienter og operasjoner",
        fun = "samlerapport1Fun",
        paramNames = c("p1", "p2", "reshID"),
        paramValues = c("Alder", 1, 999999)
      ),
      `Automatisk samlerapport2` = list(
        synopsis = "Automatisk samlerapport2 som inneholder
        enda mer spennende statistikk
        om pasienter og operasjoner, i tillegg til BMI",
        fun = "samlerapport2Fun",
        paramNames = c("p1", "p2", "reshID"),
        paramValues = c("BMI", 1, 999999)
      )
    ),
    orgs = orgs,
    user = user,
    runAutoReportButton = TRUE
  )

  ###############
  # Export data #
  ###############

  ## brukerkontroller
  rapbase::exportUCServer(
    "export",
    dbName = "data",
    teamName = Sys.getenv("SHINYPROXY_APPID", unset = "unknown")
  )
  ## veiledning
  rapbase::exportGuideServer("exportGuide", dbName = "data")
}
