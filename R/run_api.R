#' Title
#'
#' @param port port to deploy api
#'
#' @export
#'
run_api <- function(port = 9223){
  future::plan(future::multisession(workers = 10))
  plumber::plumb(file= app_sys("api_prenoms", "plumber.R"))$run(host="0.0.0.0",port = port)
}
