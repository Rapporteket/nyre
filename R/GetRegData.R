#' Provide dataframe of registry data
#'
#' Provides a dataframe containing data from a registry
#'
#' @param registryName String providing the current registryName
#' @return regData data frame
#' @export

getRegData <- function(registryName) {

  # nocov start
  query <- "
SELECT
  AvdRESH AS Avdeling,
  COUNT(*) AS n
FROM
  AlleVarNum
GROUP BY
  AvdRESH;
"

  rapbase::loadRegData(registryName, query)
  # nocov end

}
