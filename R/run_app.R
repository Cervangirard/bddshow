#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
#' @importFrom future plan multisession
run_app <- function(onStart = NULL,
                    options = list(), 
                    enableBookmarking = NULL,
                    ...) {
  plan(multisession(workers = 10))
  with_golem_options(
    app = shinyApp(ui = app_ui,
                   server = app_server,
                   onStart = onStart,
                   options = options, 
                   enableBookmarking = enableBookmarking), 
    golem_opts = list(...)
  )
}
