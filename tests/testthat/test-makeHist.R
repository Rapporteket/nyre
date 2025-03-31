test_that("a histogram can be made", {
  expect_equal(class(makeHist(mtcars, "cyl", 10)), "histogram")
})

test_that("a table can be made", {
  expect_equal(class(makeHist(mtcars, "cyl", 10, makeTable = TRUE)),
               "data.frame")
})

# clean-up
file.remove("Rplots.pdf")
