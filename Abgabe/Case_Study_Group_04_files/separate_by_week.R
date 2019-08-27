by_week <- function(components_list) {
   
  weekly_data <- vector(mode = "list", length = 16)
  names(weekly_data) <- names(components_list)

  for (component_ in components_list) {
    weekly_data[[as.character(component_[1, ]$id)]] <- plyr::ddply(component_, .variables = colnames(component_), nrow)
    weekly_data[[as.character(component_[1, ]$id)]] <- dplyr::rename(weekly_data[[as.character(component_[1, ]$id)]], amount = V1)
  }
  weekly_data
}