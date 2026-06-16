

devtools::install(".", upgrade = FALSE, dependencies = FALSE)
devtools::install("../rapbase", upgrade = FALSE, dependencies = FALSE)
source("dev/renv.R")

# Set MYSQL_HOST to "db" when running in Docker, and "localhost" when running locally
Sys.setenv(MYSQL_HOST = "db")

nyre::run_app(browser = TRUE)
