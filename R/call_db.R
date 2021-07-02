#' Call database
#'
#' @param data data form DB
#' @param prenoms prenoms to filter
#'
#' @importFrom dplyr filter group_by summarise
#' @return view of result
#' @export
#'
call_db <- function(data, prenoms){
  data %>% 
  filter(name == prenoms ) %>% 
    group_by(year) %>% 
    summarise(n = sum(n))
}


#' Connect to the good database
#'
#' @param dbname name db
#' @param host host
#' @param port port
#' @param user user
#' @param password password
#' 
#' @importFrom DBI dbCanConnect dbConnect
#' @importFrom RPostgres Postgres
#'
#' @return connect
connect_db <- function(dbname = "rr2021", 
                       host = "127.0.0.1",
                       port = 5432, 
                       user = "user",
                       password = "password"){
  
  ask <- dbCanConnect(RPostgres::Postgres(),
                           dbname = dbname, 
                           host = host,
                           port = port, 
                           user = user,
                           password = password)
  if(ask){
    con <- dbConnect(RPostgres::Postgres(),
                          dbname = dbname, 
                          host = host,
                          port = port, 
                          user = user,
                          password = password)
  }else{
    con <- NULL
  }
  list(con = con, connect = ask)
}