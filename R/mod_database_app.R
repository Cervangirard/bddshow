#' database_app UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import DBI 
mod_database_app_ui <- function(id){
  ns <- NS(id)
  tagList(
    golem_add_external_resources(),
    activate_js(),
    fluidPage(
      h2("Database example"),
      p("In this application, we are using Postgis database."),
      hr(),
      h1("Livre d'or"),
      mod_database_app_livredor_ui(ns("livredor"))
    ),
    toasts()
  )
}

#' database_app Server Function
#'
#' @noRd 
mod_database_app_server <- function(input, output, session, config){
  ns <- session$ns
  
  local <- reactiveValues()
  
  ### Connect to the database
  connect <- connect_db(dbname = config$dbname,
                        host = config$host, 
                        port = config$port,
                        user = config$user, 
                        password = config$password)
  
  observeEvent(connect,{
    if(connect$connect){
      golem::invoke_js("succes", "succes")
      table <- dbListTables(connect$con)
      test <- any(grepl(pattern = "feedback", x = table))
      if(!test){
        df <- data.frame("date" = "", "feedback"= "", "emoji" = "")
        dbCreateTable(connect$con, "feedback", df)
        local$data <- df
      }else{
        local$data <- dbReadTable(connect$con, "feedback")
      }
      
    }else{
      golem::invoke_js("succes", "error")
    }
  })
  
  callModule(mod_database_app_livredor_server, "livredor", r = local, connect = connect)
  
  # shiny::onSessionEnded(DBI::dbDisconnect(connect$con))
}

## To be copied in the UI
# mod_database_app_ui("database_app_ui_1")

## To be copied in the server
# callModule(mod_database_app_server, "database_app_ui_1")

