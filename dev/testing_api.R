### testing api

library(purrr)
library(promises)
library(future)

plan(multisession)
tictoc::tic()

map(c("Vincent", "Diane", "Colin", "Sebastien", "Margot", "Vincent", "Diane", "Colin"), ~ {
  prenom <- .x
  future::future({
    url_call <-
      paste0(Sys.getenv("URL_API", "http://api.cervangirard.me:9223"),
             "/data?prenom=",
             prenom)
    httr::GET(URLencode(url_call)) %>%
      httr::content() %>%
      purrr::map_df(~ tibble::as_tibble(.x, .name_repair = "universal"))
  }) %...>%
    print()
})
tictoc::toc() 