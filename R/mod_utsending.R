#' Shiny module providing GUI and server logic for the dispatch tab
#'
#' @param id Character string module namespace
NULL

utsending_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::sidebarLayout(
    shiny::sidebarPanel(
      width = 3,
      shiny::uiOutput(ns("report")),
      shiny::uiOutput(ns("freq")),
      shiny::textInput(ns("email"), "Epostmottakere:"),
      shiny::uiOutput(ns("editEmail")),
      shiny::htmlOutput(ns("recipients")),
      shiny::tags$hr(),
      shiny::uiOutput(ns("makeDispatchment"))
    ),
    shiny::mainPanel(
      shiny::uiOutput(ns("dispatchmentContent"))
    )
  )
}

utsending_server <- function(id) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      # Utsending
      ## reaktive verdier for aa holde rede paa endringer som skjer mens
      ## applikasjonen kjorer
      dispatchment <- shiny::reactiveValues(
        tab = rapbase::makeAutoReportTab(session = session, type = "dispatchment"),
        report = "Automatisk samlerapport1",
        freq = "M\u00E5nedlig-month",
        email = vector()
      )

      ## observer og foreta endringer mens applikasjonen kjorer
      shiny::observeEvent(input$addEmail, {
        dispatchment$email <- c(dispatchment$email, input$email)
      })
      shiny::observeEvent(input$delEmail, {
        dispatchment$email <-
          dispatchment$email[!dispatchment$email == input$email]
      })
      shiny::observeEvent(input$dispatch, {
        package <- "rapRegTemplate"
        type <- "dispatchment"
        owner <- rapbase::getUserName(session)
        ownerName <- rapbase::getUserFullName(session)
        interval <- strsplit(input$dispatchmentFreq, "-")[[1]][2]
        intervalName <- strsplit(input$dispatchmentFreq, "-")[[1]][1]
        runDayOfYear <- rapbase::makeRunDayOfYearSequence(
          interval = interval
        )

        email <- dispatchment$email
        organization <- rapbase::getUserReshId(session)

        if (input$dispatchmentRep == "Automatisk samlerapport1") {
          synopsis <- "Automatisk samlerapport1"
          fun <- "samlerapport1Fun"
          paramNames <- c("p1", "p2")
          paramValues <- c("Alder", 1)

        }
        if (input$dispatchmentRep == "Automatisk samlerapport2") {
          synopsis <- "Automatisk samlerapport2"
          fun <- "samlerapport2Fun"
          paramNames <- c("p1", "p2")
          paramValues <- c("BMI", 2)
        }
        rapbase::createAutoReport(synopsis = synopsis, package = package,
                                  type = type, fun = fun, paramNames = paramNames,
                                  paramValues = paramValues, owner = owner,
                                  ownerName = ownerName,
                                  email = email, organization = organization,
                                  runDayOfYear = runDayOfYear,
                                  interval = interval, intervalName = intervalName)
        dispatchment$tab <-
          rapbase::makeAutoReportTab(session, type = "dispatchment")
        dispatchment$email <- vector()
      })

      ## ui: velg rapport
      output$report <- shiny::renderUI({
        shiny::selectInput(
          ns("dispatchmentRep"), "Rapport:",
          c("Automatisk samlerapport1", "Automatisk samlerapport2"),
          selected = dispatchment$report
        )
      })

      ## ui: velg frekvens
      output$freq <- shiny::renderUI({
        shiny::selectInput(
          ns("dispatchmentFreq"), "Frekvens:",
          list("\u00C5rlig" = "\u00C5rlig-year",
               Kvartalsvis = "Kvartalsvis-quarter",
               Maanedlig = "M\u00E5nedlig-month",
               Ukentlig = "Ukentlig-week",
               Daglig = "Daglig-DSTday"),
          selected = dispatchment$freq
        )
      })

      ## ui: legg til gyldig- og slett epost
      output$editEmail <- shiny::renderUI({
        if (!grepl("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
                   input$email)) {
          shiny::tags$p("Angi mottaker over")
        } else {
          if (input$email %in% dispatchment$email) {
            shiny::actionButton("delEmail", "Slett epostmottaker",
                                icon = shiny::icon("trash"))
          } else {
            shiny::actionButton("addEmail", "Legg til epostmottaker",
                                icon = shiny::icon("pencil"))
          }
        }
      })

      ## ui: vis valgte mottakere
      output$recipients <- shiny::renderText(paste(dispatchment$email,
                                                   sep = "<br>"))

      ## ui: lag ny utsending
      output$makeDispatchment <- shiny::renderUI({
        if (length(dispatchment$email) == 0) {
          NULL
        } else {
          shiny::actionButton("dispatch", "Lag utsending",
                              icon = shiny::icon("save"))
        }
      })

      ## lag tabell over gjeldende status for utsending
      output$activeDispatchments <- DT::renderDataTable(
        dispatchment$tab, server = FALSE, escape = FALSE, selection = "none",
        options = list(dom = "tp", ordering = FALSE), rownames = FALSE
      )


      ## ui: lag side som viser status for utsending, ogsaa naar det ikke finnes noen
      output$dispatchmentContent <- shiny::renderUI({
        if (length(dispatchment$tab) == 0) {
          shiny::p("Det finnes ingen utendinger")
        } else {
          shiny::tagList(
            shiny::p("Aktive utsendinger:"),
            DT::dataTableOutput("activeDispatchments")
          )
        }
      })

      # Rediger eksisterende auto rapport (alle typer)
      shiny::observeEvent(input$edit_button, {
        repId <- strsplit(input$edit_button, "_")[[1]][2]
        rep <- rapbase::readAutoReportData()[[repId]]
        if (rep$type == "subscription") {

        }
        if (rep$type == "dispatchment") {
          dispatchment$freq <- paste0(rep$intervalName, "-", rep$interval)
          dispatchment$email <- rep$email
          rapbase::deleteAutoReport(repId)
          dispatchment$tab <-
            rapbase::makeAutoReportTab(session, type = "dispatchment")
          dispatchment$report <- rep$synopsis
        }
        if (rep$type == "bulletin") {

        }
      })

      # Slett eksisterende auto rapport (alle typer)
      shiny::observeEvent(input$del_button, {
        repId <- strsplit(input$del_button, "_")[[1]][2]
        rapbase::deleteAutoReport(repId)
        subscription$tab <-
          rapbase::makeAutoReportTab(session, type = "subscription")
        dispatchment$tab <-
          rapbase::makeAutoReportTab(session, type = "dispatchment")
      })
    }
  )
}
