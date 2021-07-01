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

future::plan(future::multisession)

#* @apiTitle Give data to made graph in app

#* Calcul data for the graph
#* @param prenom give a prenom to calcul the data
#* @serializer json
#* @get /data
function(prenom = "Vincent") {
 ok <-  future::future({
    Sys.sleep(3)
    prenoms::prenoms %>%
      dplyr::filter(name == prenom ) %>% 
      dplyr::group_by(year) %>% 
      dplyr::summarise(n = sum(n))
  }, packages = c("dplyr")) %...>%
  print()

  message("Calculate")
 
 ok
}
