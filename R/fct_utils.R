#' Toasts
#'
toasts <- function() {
  tagList(
    div(id = "succes", 
        class = "succes card-book",
        p("Successful connection!")
    ),
    div(id = "error",
        class = "error card-book",
        p("Connection Error!")
    )
  )
} 


#' refresh table
#'
#' @param id id input
#' @param id_refresh_msg id refrech message
#' @param session session
refresh <- function(id, id_refresh_msg, session = getDefaultReactiveDomain()){
  tagList(
    div(
      icon("sync") %>%
        htmltools::tagAppendAttributes(
          onclick = paste0(
            "Shiny.setInputValue('",
            id,
            "', value = Math.random())"),
          style= "cursor: pointer;")
    ),
    div(
      id= id_refresh_msg,
      class = 'card-book succes',
      p("Done !")
    )
  )
}


#' validate need together
#'
#' @param ... condition
#' @param msg msg
not_validate <- function(...,msg){
  validate(
    need(..., message = msg)
  )
}

#' Heart
#' 
#' @param id id
heart <- function(id){
  htmltools::HTML(
    sprintf('<svg id="%s" class="heart" viewBox="0 0 32 29.6">
      <path d="M23.6,0c-3.4,0-6.3,2.7-7.6,5.6C14.7,2.7,11.8,0,8.4,0C3.8,0,0,3.8,0,8.4c0,9.4,9.5,11.9,16,21.2 c6.1-9.3,16-12.1,16-21.2C32,3.8,28.2,0,23.6,0z"/>
      </svg> ', 
            id
    )
  )
}