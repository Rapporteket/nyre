test_that("PlotAndelerGrVar handles empty data gracefully", {
    RegData <- data.frame()
    plot <- PlotAndelerGrVar(RegData, Variabel = numeric(0))
    expect_s3_class(plot, "ggplot")
})

test_that("PlotAndelerGrVar handles minimal data correctly", {
    RegData <- data.frame(ShNavn = c("Group1", "Group2"), Variabel = c(1, 0))
    plot <- PlotAndelerGrVar(RegData, Variabel = RegData$Variabel)
    expect_s3_class(plot, "ggplot")
})

test_that("PlotAndelerGrVar applies group filtering correctly", {
    RegData <- data.frame(ShNavn = c("Group1", "Group2", "Group3"), Variabel = c(0.5, 0.3, 1))
    plot <- PlotAndelerGrVar(RegData, Variabel = RegData$Variabel, Ngrense = 1)
    expect_s3_class(plot, "ggplot")
    expect_equal_to_reference(plot$data$andelTekst, "data/testfil.rds")
})

test_that("PlotAndelerGrVar handles NA values in data", {
    RegData <- data.frame(ShNavn = c("Group1", "Group2"), Variabel = c(NA, 2))
    plot <- PlotAndelerGrVar(RegData, Variabel = RegData$Variabel)
    expect_s3_class(plot, "ggplot")
})

test_that("PlotAndelerGrVar applies custom title and subtitle", {
    RegData <- data.frame(ShNavn = c("Group1", "Group2"), Variabel = c(1, 2))
    plot <- PlotAndelerGrVar(
      RegData,
      Variabel = RegData$Variabel,
      tittel = "Custom Title",
      utvalgTxt = "Custom Subtitle",
      Ngrense = 0
    )
    expect_s3_class(plot, "ggplot")
    expect_equal("Custom Title", plot$labels$title)
    expect_equal("Custom Subtitle", plot$labels$subtitle)
})
