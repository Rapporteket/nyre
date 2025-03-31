#' Provide dataframe of fake registry data
#'
#' Provides a dataframe containing built-in data (and not a registry) for demo
#' purposes
#'
#' @return regData data frame
#' @export

getFakeRegData <- function() {

  regData <- datasets::mtcars

  return(regData)
}
