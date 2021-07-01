#' all_annee UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import dplyr
#' @importFrom stringr str_detect
#' @importFrom promises %...>%
mod_all_annee_ui <- function(id) {
  ns <- NS(id)
  tagList(h2("Evolution de votre prenom en fonction des ann\u00E9es"),
          fluidRow(
            column(
              2,
              textInput(ns("search"), 'Tapez les premi\u00E8res lettres :'),
              selectizeInput(ns("prenom"), label = "Choissisez votre prenom", choices = NULL)
            ),
            column(8,
                   plotOutput(ns("graph")))
            
          ))
}

#' all_annee Server Functions
#'
#' @noRd
mod_all_annee_server <- function(id, global, connect) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    thematic::thematic_shiny()
    
    local <- reactiveValues()
    
    observeEvent(connect$connect, {
      local$only_prenoms <- tbl(connect$con, "only_prenoms")
    })
    
    observeEvent(input$search, {
      req(input$search)
      
      prenoms <- local$only_prenoms %>%
        filter(str_detect(name, paste0("^", local(input$search)))) %>%
        collect()
      updateSelectizeInput(
        session = session,
        inputId = "prenom",
        choices = prenoms,
        server = FALSE
      )
      
    })
    
    
    rv_plot <- reactiveVal(NULL)
    
    observeEvent(c(global$dark_mode, input$prenom), {
      req(input$prenom)
      
      dark_mode <- global$dark_mode
      
      prenom <- input$prenom
      url_call <-
        paste0(Sys.getenv("URL_API", "http://127.0.0.1:9223"),
               "/data?prenom=",
               prenom)
      
      future::future({
        Sys.sleep(0.1)
        list(
          data = 
            # call_api(url_call),
            httr::GET(URLencode(url_call)) %>%
            httr::content() %>%
            purrr::map_df( ~ tibble::as_tibble(.x, .name_repair = "universal")),
          prenom = prenom,
          random = dark_mode
        )
      }) %...>%
        (function(info) {
          graph_evol(info$data, info$prenom) +
            labs(subtitle = dark_mode)
        }) %...>%
        rv_plot() 
      
      message("Compute")
    })
    
    output$graph <- renderPlot({

        rv_plot() %>%
          print()
    }) %>%
      bindCache(rv_plot())
    
  })
}

## To be copied in the UI
# mod_all_annee_ui("all_annee_ui_1")

## To be copied in the server
# mod_all_annee_server("all_annee_ui_1")
