test_that("makeHist creates a ggplot object", {
  df <- data.frame(x = c(1, 2, 3, 4), var = c(5, 6, 7, 8))
  plot <- makeHist(df, x = df$x, var = df$var)
  expect_s3_class(plot, "ggplot")
})

test_that("makeSimpleHist returns a histogram object", {
  df <- data.frame(mpg = c(21, 22, 23, 24, 25))
  hist_obj <- makeSimpleHist(df, var = "mpg", bins = 3, makeTable = FALSE)
  expect_true(is.list(hist_obj))
  expect_true("counts" %in% names(hist_obj))
})

test_that("makeSimpleHist returns a data frame when makeTable is TRUE", {
  df <- data.frame(mpg = c(21, 22, 23, 24, 25))
  table <- makeSimpleHist(df, var = "mpg", bins = 3, makeTable = TRUE)
  expect_s3_class(table, "data.frame")
  expect_equal(ncol(table), 3)
  expect_true(all(c("GruppeMin", "GruppeMax", "Antall") %in% names(table)))
})
