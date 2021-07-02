#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom journuit init_cookie_theme change_theme
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  
  global <- reactiveValues()
  
  observeEvent(session,{
    init_cookie_theme(input$dark_mode)
    global$dark_mode <- input$dark_mode
    

  }, once = TRUE)
  
  observeEvent(input$dark_mode,{
    
    change_theme(input$dark_mode)
    
    global$dark_mode <- input$dark_mode
  }, ignoreInit = TRUE)
  
  
  config <- list(dbname = Sys.getenv("POSTGRES_DB","rr2021"),
                 host = Sys.getenv("HOST","127.0.0.1"),
                 port = Sys.getenv("PORT",5432),
                 user = Sys.getenv("POSTGRES_USER","cervan"),
                 password = Sys.getenv("POSTGRES_PASSWORD","ok"))
  
  callModule(mod_database_app_server, "ok", config, global)
}
