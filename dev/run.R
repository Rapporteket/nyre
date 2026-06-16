

devtools::install(".", upgrade = FALSE, dependencies = FALSE)
devtools::install("../rapbase", upgrade = FALSE, dependencies = FALSE)
source("dev/renv.R")
nyre::run_app(browser = TRUE)
