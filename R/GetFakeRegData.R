#' Provide dataframe of fake registry data
#'
#' Provides a dataframe containing built-in data (and not a registry) for demo
#' purposes
#'
#' @return regData data frame
#' @export

getFakeRegData <- function() {
  cases_year
}

getFakeRegData2 <- function() {
  penguin_bool <- palmerpenguins::penguins |>
    dplyr::mutate(
      heavy        = .data$body_mass_g >= 4000,
      long_bill    = .data$bill_length_mm >= 45,
      deep_bill    = .data$bill_depth_mm >= 18,
      long_flipper = .data$flipper_length_mm >= 200,
      male         = .data$sex == "male"
    )
  attr(penguin_bool, "kvalIndGrenser") <- list(
    # fikive kvalitetsindikatorer
    heavy        = c(0, 30, 60, 100),
    long_bill    = NA,
    deep_bill    = NA,
    long_flipper = c(0, 35, 70, 100),
    male         = NA
  )
  penguin_bool

}
