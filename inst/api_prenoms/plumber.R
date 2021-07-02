#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(dplyr)
library(prenoms)
library(promises)
library(future)

# future::plan(future::multisession(workers = 10))

#* @apiTitle Give data to made graph in app

#* Calcul data for the graph
#* @param prenom give a prenom to calcul the data
#* @serializer json
#* @get /data
function(prenom = "Vincent") {
 ok <-  promises::as.promise(future::future({
    prenoms::prenoms %>%
      dplyr::filter(name == prenom ) %>% 
      dplyr::group_by(year) %>% 
      dplyr::summarise(n = sum(n))
  }, packages = c("dplyr")) )

  message("Calculate")
 
 ok
}