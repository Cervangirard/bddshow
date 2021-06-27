#' Title
#'
#' @param port port to deploy api
#'
#' @export
#'
run_api <- function(port = 9223){
  plumber::plumb(file= app_sys("api_prenoms", "plumber.R"))$run(port = port)
}
