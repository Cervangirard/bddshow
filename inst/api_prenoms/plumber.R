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

future::plan(future::multisession)

#* @apiTitle Give data to made graph in app

#* Calcul data for the graph
#* @param prenom give a prenom to calcul the data
#* @serializer json
#* @get /data
function(prenom = "Vincent") {
 ok <-  promises::future_promise({
    prenoms::prenoms %>%
      filter(name == prenom ) %>% 
      group_by(year) %>% 
      summarise(n = sum(n))
  })
 
 message("Calculate")
 
 ok
}
