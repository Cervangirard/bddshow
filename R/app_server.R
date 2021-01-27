#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  config <- list(dbname = Sys.getenv("NAME_BDD_POSTGIS","itdd"),
                 host = Sys.getenv("HOST_POSTGIS","127.0.0.1"),
                 port = Sys.getenv("PORT_POSTGIS",5432),
                 user = Sys.getenv("USER_POSTGIS","user"),
                 password = Sys.getenv("PASSWORD_POSTGIS","password"))
  
  callModule(mod_database_app_server, "ok", config)
}
