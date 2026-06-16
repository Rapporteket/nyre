###--------------------------------------------------------------------------###
# Funksjoner til modulen "Over Tid"
###--------------------------------------------------------------------------###

#' Funksjon for å gjøre utvalg basert på ui-valg om variabel og region
#' @param data dataramme (her brukes data på meslinger)
#' @param var variabelen som velges av bruker i ui-delen
#' @param valg_region valg av region gjort av bruker i ui-delen
#' @export

over_tid_utvalg <- function(data, var, valg_region) {

  data <- data |>
    dplyr::select(.data$year, .data$region, dplyr::all_of(!!var))

  gj_alle <- data |>
    dplyr::rename(variabelen = {{var}}) |>
    dplyr::group_by(.data$year) |>
    dplyr::summarize(gjennomsnitt = mean(.data$variabelen)) |>
    dplyr::mutate(gjennomsnitt = round(.data$gjennomsnitt, 2)) |>
    dplyr::rename(gj_alle = .data$gjennomsnitt)

  data <- data |>
    dplyr::filter(.data$region == dplyr::case_when(
      {{valg_region}} == "AFRO" ~ "AFRO",
      {{valg_region}} == "AMRO" ~ "AMRO",
      {{valg_region}} == "EMRO" ~ "EMRO",
      {{valg_region}} == "EURO" ~ "EURO",
      {{valg_region}} == "SEARO" ~ "SEARO",
      {{valg_region}} == "WPRO" ~ "WPRO",
      {{valg_region}} == "Alle" ~ region,
      {{valg_region}} == "Alle_delt" ~ region
    ))

  gj <- data |>
    dplyr::rename(variabelen = {{var}}) |>
    dplyr::group_by(.data$year, .data$region) |>
    dplyr::summarize(gjennomsnitt = mean(.data$variabelen)) |>
    dplyr::mutate(gjennomsnitt = round(.data$gjennomsnitt, 2))

  gj <- dplyr::left_join(gj, gj_alle)

  if (valg_region == "Alle") {
    return(gj_alle)
  } else {
    return(gj)
  }

}


#' Funksjon for å lage kolonne-figur for datasettet med meslinger
#' @param data datasett som har vært gjennom over_tid_utvalg()
#' @param valg_region valg av region-visning gjort av bruker i ui-delen
#' @return en "stacked columns"-figur
#' @export

over_tid_plot <- function(data, valg_region) {

  tid_plot <- ggplot2::ggplot()

  if (valg_region == "Alle_delt") {
    tid_plot <- tid_plot +
      ggplot2::geom_col(data = data, ggplot2::aes(x = .data$year, y = .data$gjennomsnitt, fill = .data$region)) +
      ggplot2::scale_fill_brewer(palette = "Set3") +
      ggplot2::labs(fill = "Region")
  } else {
    if (valg_region == "Alle") {
      tid_plot <- tid_plot +
        ggplot2::geom_col(data = data, ggplot2::aes(x = .data$year, y = .data$gj_alle), fill = "#6CACE4", alpha = .7)
    } else {
      data <- data |>
        dplyr::mutate(Verden = "Verden (gj.snitt)")
      tid_plot <- tid_plot +
        ggplot2::geom_col(
          data = data,
          ggplot2::aes(x = .data$year, y = .data$gjennomsnitt, fill = .data$region), alpha = .7
        ) +
        ggplot2::geom_point(data = data, ggplot2::aes(x = .data$year, y = .data$gj_alle, color = .data$Verden)) +
        ggplot2::scale_color_manual(values = c("Verden (gj.snitt)" = "#003087")) +
        ggplot2::scale_fill_manual(values = c("#6CACE4"))
    }
  }

  tid_plot <- tid_plot +
    ggplot2::ylab("") +
    ggplot2::xlab("År") +
    ggplot2::theme_bw() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 10),
                   legend.position = "right",
                   legend.title = ggplot2::element_blank())

  return(tid_plot)
}
