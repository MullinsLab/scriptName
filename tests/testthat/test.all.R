context("source()")
test_that("source()", {
    expect_output(source("source.current_filename.R"),        "source.current_filename.R")
    expect_output(source("source.current_source_filename.R"), "source.current_source_filename.R")
    expect_silent(source("source.current_cli_filename.R"))
})


context("R --file")
test_that("R --file", {
    args = c("--slave", "--no-save", "--no-restore", "--file=red-herring.R")

    expect_identical(system2("R", c(args, "--file=exec.current_filename.R"),        stdout = T), "exec.current_filename.R")
    expect_identical(system2("R", c(args, "--file=exec.current_source_filename.R"), stdout = T), character(0))
    expect_identical(system2("R", c(args, "--file=exec.current_cli_filename.R"),    stdout = T), "exec.current_cli_filename.R")
})


context("R -f")
test_that("R -f", {
    args = c("--slave", "--no-save", "--no-restore", "-f", "red-herring.R")

    expect_identical(system2("R", c(args, "-f", "exec.current_filename.R"),        stdout = T), "exec.current_filename.R")
    expect_identical(system2("R", c(args, "-f", "exec.current_source_filename.R"), stdout = T), character(0))
    expect_identical(system2("R", c(args, "-f", "exec.current_cli_filename.R"),    stdout = T), "exec.current_cli_filename.R")
})


context("Rscript")
test_that("Rscript", {
    expect_identical(system2("Rscript", "exec.current_filename.R",        stdout = T), "exec.current_filename.R")
    expect_identical(system2("Rscript", "exec.current_source_filename.R", stdout = T), character(0))
    expect_identical(system2("Rscript", "exec.current_cli_filename.R",    stdout = T), "exec.current_cli_filename.R")
})
