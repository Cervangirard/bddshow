#' Graphique sur l'evolution d'un prenoms dans le temps
#'
#' @param data deja filter avec le prenom
#' @param prenoms prenoms à afficher
#'
#' @importFrom ggplot2 ggplot aes geom_line labs theme_bw theme element_blank
#'
#' @return
#' ggplot
#' @export
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' data <- prenoms::prenoms %>%
#'  filter(name == "Vincent" ) %>% 
#'  group_by(year) %>% 
#'  summarise(n = sum(n))
#' 
#' graph_evol(data, "Vincent")}
graph_evol <- function(data, prenoms) {
  ## TODO check names
  data %>% 
    ggplot() +
    aes(x = year, y = n) +
    geom_line(color = "#4a4f93") +
    labs(x = "Ann\u00E9es", y = "Total naissance", title = paste0("Evolution de ", prenoms)) +
    # Pour le thematic shiny 
    theme(plot.subtitle = element_blank())
}