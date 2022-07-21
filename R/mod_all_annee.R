#' all_annee UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom stringr str_detect str_to_sentence
#' @importFrom dplyr tbl collect filter pull
#' @importFrom ggplot2 labs
#' @importFrom httr GET content
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
#' @importFrom promises %...>% %...!%
#' @importFrom thematic thematic_shiny
#' @importFrom cachem cache_disk

mod_all_annee_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Evolution de votre prenom en fonction des ann\u00E9es"),
    fluidRow(
      column(
        2,
        textInput(ns("search"),
                  'Tapez les premi\u00E8res lettres :'),
        selectizeInput(ns("prenom"),
                       label = "Choissisez votre prenom",
                       choices = NULL),
        actionButton(ns("go"), "Lancer le calcul !")
      ),
      column(8,
             plotOutput(ns("graph")))
      
    )
  )
}

#' all_annee Server Functions
#'
#' @noRd
mod_all_annee_server <- function(id, global, connect) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    thematic::thematic_shiny()
    
    cache <- cache_disk(dir = get_dir_cached())
    
    local <- reactiveValues()
    
    observeEvent(connect$connect, {
      local$only_prenoms <- tbl(connect$con, "only_prenoms")
    })
    
    observeEvent(input$search, {
      req(input$search)
      prenoms <- local$only_prenoms %>%
        filter(str_detect(name, paste0("^", local(str_to_sentence(input$search))))) %>%
        pull()
      
      updateSelectizeInput(
        session = session,
        inputId = "prenom",
        choices = prenoms,
        server = FALSE
      )
      
    })
    
    rv_plot <- reactiveVal(NULL)
    
    observeEvent(input$go, {
      req(input$prenom)
      
      url_health <- paste0(Sys.getenv("URL_API", "http://127.0.0.1:9223"), "/health")

      status <- try({
        httr::GET(url_health) %>% 
          httr::status_code()
      }, silent = TRUE)
      
      if(status != 200 | inherits(status,"try-error")){
        golem::invoke_js("succes", "error_api")
        return(NULL)
      }
      
      showNotification(
        id = "notif",
        ui = tagList(p("Graph en cours!")),
        closeButton = FALSE,
        duration = NULL,
        type = "warning"
      )
      
     
      cache_key <- digest::digest(list(input$prenom
                                       # , global$dark_mode
                                       )
                                  )
      
      prenom <- input$prenom
      url_call <-
        paste0(Sys.getenv("URL_API", "http://127.0.0.1:9223"),
               "/data?prenom=",
               prenom)
      if (cache$exists(cache_key)) {
        cli::cat_rule("cache exists")
        
        results <- cache$get(cache_key)
        results[[2]] %>%
          rv_plot()
      } else{
        future::future({
          
          Sys.sleep(3)
          
          list(
            data =
              httr::GET(URLencode(url_call)) %>%
              httr::content() %>%
              purrr::map_df( ~ tibble::as_tibble(.x, .name_repair = "universal")),
            prenom = prenom
          )
        }) %...!%
          (function(error) {
            warning(error)
            NULL
          }) %...>%
          (function(info) {
            graph <- graph_evol(info$data, info$prenom) +
              labs(subtitle = info$prenom)
            cache$set(cache_key, list(info$prenom, graph))
            graph
          }) %...>%
          rv_plot()
      }
      
      message("Compute")
    })
    
    output$graph <- renderPlot({
      removeNotification("notif")
      # validate(need(!is.null(
      #   rv_plot(), message("Problème avec le calcul")
      # )))
      rv_plot() %>%
        print()
    })
    
    
  })
}

## To be copied in the UI
# mod_all_annee_ui("all_annee_ui_1")

## To be copied in the server
# mod_all_annee_server("all_annee_ui_1")
