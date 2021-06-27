#' Call Api with one prenom
#'
#' @param url_call call for the api
#' 
#' @importFrom purrr map_df
#' @importFrom httr GET content
#' @importFrom utils URLencode
#' @importFrom tibble as_tibble
#' 
#' @return data.frame
#' @export
#'
call_api <- function(url_call){
 data <-  httr::GET(URLencode(url_call)) %>% 
    httr::content() %>% 
    purrr::map_df(~ tibble::as_tibble(.x, .name_repair = "universal"))
 
 if(nrow(data) > 1){
   data
 }else{
   NULL
 }
}
