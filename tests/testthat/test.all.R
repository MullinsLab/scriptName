library(rlang)

R       <- file.path(R.home("bin"), "R")
Rscript <- file.path(R.home("bin"), "Rscript")

context("source()")
test_that("functions work under source()", {
    source_file <- function(file)
       system2(Rscript, c("--vanilla", "-e", shQuote(paste0('source("', file, '")'))), stdout = T)

    expect_identical(source_file("current_filename.R"),         ' chr "current_filename.R"')
    expect_identical(source_file("current_source_filename.R"),  ' chr "current_source_filename.R"')
    expect_identical(source_file("current_cli_filename.R"),     ' NULL')
})


context("R --file")
test_that("functions work under R --file", {
    run_r <- function(file)
       system2(R, c("--slave", "--vanilla", "--file=red-herring.R", paste0("--file=", file)), stdout = T)

    expect_identical(run_r("current_filename.R"),         ' chr "current_filename.R"')
    expect_identical(run_r("current_source_filename.R"),  ' NULL')
    expect_identical(run_r("current_cli_filename.R"),     ' chr "current_cli_filename.R"')
})


context("R -f")
test_that("functions work under R -f", {
    run_r <- function(file)
       system2(R, c("--slave", "--vanilla", "-f", "red-herring.R", "-f", file), stdout = T)

    expect_identical(run_r("current_filename.R"),         ' chr "current_filename.R"')
    expect_identical(run_r("current_source_filename.R"),  ' NULL')
    expect_identical(run_r("current_cli_filename.R"),     ' chr "current_cli_filename.R"')
})


context("Rscript")
test_that("functions work under Rscript", {
    run_rscript <- function(file)
       system2(Rscript, c("--vanilla", file), stdout = T)

    expect_identical(run_rscript("current_filename.R"),         ' chr "current_filename.R"')
    expect_identical(run_rscript("current_source_filename.R"),  ' NULL')
    expect_identical(run_rscript("current_cli_filename.R"),     ' chr "current_cli_filename.R"')
})
