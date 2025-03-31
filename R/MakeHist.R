#' Make a histogram, either plot or its data
#'
#' Short demo on how to produce dynamic content in a shiny app at Rapporteket
#'
#' @param df dataframe from which output is to be made
#' @param var string defining which varable in the data frame to use
#' @param bins numeric vector defining the number of equally large groups
#' @param makeTable Logical that if TRUE function will return a data frame
#' containin the bin borders and count within each bin
#'
#' @return a graphical object or data frame
#' @export
#'
#' @examples
#' makeHist(df = mtcars, var = "mpg", bins = 5, makeTable = FALSE)

makeHist <- function(df, var, bins, makeTable = FALSE) {

  x <- df[[var]]
  bins <- seq(min(x), max(x), length.out = bins + 1)
  t <- graphics::hist(
    x,
    breaks = bins,
    col = "#154ba2",
    border = "white",
    main = paste("Fordeling av", var),
    xlab = var,
    ylab = "Antall"
  )
  if (makeTable) {
    data.frame(GruppeMin = t$breaks[seq_len(length(t$mids))],
               GruppeMax = t$breaks[2:(length(t$mids) + 1)], Antall = t$counts)
  } else {
    t
  }
}
