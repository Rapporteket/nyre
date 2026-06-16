#' Provides a dataframe containing data from a registry
#'
#' @return regData data frame
#' @export

getRegData <- function() {

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

  rapbase::loadRegData("data", query)
  # nocov end

}
