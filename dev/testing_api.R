### testing api

library(purrr)
library(promises)
tictoc::tic()
map(c("Vincent", "Diane", "Colin", "Sebastien", "Margot"), ~ {
  prenom <- .x
  future::future({
    url_call <-
      paste0(Sys.getenv("URL_API", "http://127.0.0.1:9223"),
             "/data?prenom=",
             prenom)
    httr::GET(URLencode(url_call)) %>%
      httr::content() %>%
      purrr::map_df(~ tibble::as_tibble(.x, .name_repair = "universal"))
  }) %...>%
    print()
})
tictoc::toc() 