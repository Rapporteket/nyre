#' Example report function 1
#'
#' @param file Path to the output file.
#' If NULL, a temporary file will be created.
#' @param p1 Parameter 1 (default: "Alder")
#' @param p2 Parameter 2 (default: 1)
#' @param reshID ReshID (default: 999999)
#'
#' @return Path to the generated report file
#' @export

samlerapport1Fun <- function(file = NULL, p1 = "Alder", p2 = 1, reshID = 999999) {

  if (is.null(file)) {
    file <- base::tempfile(fileext = ".pdf")
  }

  grDevices::pdf(file)
  graphics::plot.new()
  graphics::text(0.5, 0.9, "Samlerapport 1", cex = 2, font = 2)
  grDevices::dev.off()

  return(file)
}

#' Example report function 2
#'
#' @param file Path to the output file. If NULL, a temporary file will be created.
#' @param p1 Parameter 1 (default: "Alder")
#' @param p2 Parameter 2 (default: 1)
#' @param reshID ReshID (default: 999999)
#'
#' @return Path to the generated report file
#' @export

samlerapport2Fun <- function(file = NULL, p1 = "Alder", p2 = 1, reshID = 999999) {

  if (is.null(file)) {
    file <- base::tempfile(fileext = ".pdf")
  }

  grDevices::pdf(file)
  graphics::plot.new()
  graphics::text(0.5, 0.9, "Samlerapport 2", cex = 2, font = 2)
  grDevices::dev.off()

  return(file)
}
