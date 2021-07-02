#' Title
#'
#' @param port port to deploy api
#'
#' @export
#' 
#' @importFrom plumber plumb
#' @importFrom future plan multisession
#'
run_api <- function(port = 9223){
  plan(multisession(workers = get_workers()))
  plumb(file= app_sys("api_prenoms", "plumber.R"))$run(host="0.0.0.0",port = port)
}
