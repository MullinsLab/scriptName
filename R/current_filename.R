#' @importFrom rlang %||%
#'
#' @title Determine a script's filename from within the script itself
#'
#' @description
#' A small set of functions wrapping up the call stack and command line
#' inspection needed to determine a running script's filename from within the
#' script itself.
#'
#' @details
#' `current_filename()` returns the result of `current_source_filename()` if
#' not NULL, otherwise the result of `current_cli_filename()`, which might be
#' NULL.  You should use this wrapper function rather than the more-specific
#' functions unless you have a very specific need.
#'
#' `current_source_filename()` returns the filename from the most recent call
#' to \code{\link[base]{source}} in the current call stack.  From within a
#' sourced script, this is the filename of the script itself.
#'
#' `current_cli_filename()` returns the filename found on the command line
#' invocation of R or Rscript.  This may or may not be the caller's file if
#' there's been an intervening \code{\link[base]{source}}.
#'
#' @return
#' A character vector of length 1 if a script name can be found, otherwise
#' NULL.  No manipulation is done to the filename, so it may be relative or
#' absolute.
#'
#' @examples
#' # Put this in example.R and try running source("example.R")
#' # and `Rscript example.R`
#' filename <- current_filename()
#' print(filename)
#'
#' @export
#'
current_filename <- function()
    current_source_filename() %||%
    current_cli_filename() 


#' @rdname current_filename
#' @export
#'
current_source_filename <- function()
    purrr::pluck( closest_source_frame(), "env", "filename" )

get_stack <- function (n = NULL, trim = 0) {
  stack <- sys.calls()
  stack <- rev(stack[-length(stack)])
  env <- sys.frames()
  env <- rev(env[-length(env)])
  if(length(stack) == 0) return(NULL)
  purrr::transpose(list(fn_name = lapply(stack, rlang::call_name), env = env) )
}

closest_source_frame <- function() {
  purrr::detect( get_stack(), function(x) {
    if(is.null(x$fn_name)) return(FALSE)
    x$fn_name == "source"
  })
}



#' @rdname current_filename
#' @export
#'
current_cli_filename <- function() {
    # Examples:
    #   R --slave --no-save --no-restore -f foo.R
    #   Rscript foo.R becomes R … --file=foo.R
    #
    # The last provided -f/--file argument wins (although all named files must
    # _exist_, only the last is executed), so we search in reverse since it's
    # easier to grab the first item.
    args <- rev(commandArgs(F))

    file_index <- grep("^(--file=|-f$)", args)[1]

    # No argument found
    if (is.na(file_index))
        NULL

    # -f filename: return the next argument (minus 1 because we're reversed)
    else if (args[file_index] == "-f")
        args[file_index - 1]

    # --file=filename: remove the option name
    else
        sub("^--file=", "", args[file_index])
}
