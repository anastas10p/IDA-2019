by_week <- function(components_list){
  
  yearly_data <- vector(mode="list", length=9)
  names(yearly_data) <- sprintf("%d", seq(from=2008, to=2016))
  
  component_names <- c("K3AG2", "K7")
  weekly_data <- vector(mode="list", length=2)
  names(weekly_data) <- component_names
  
  for (component_ in components_list) {
    weekly_data[[as.character(component_[1,]$id)]] <- plyr::ddply(k7, .variables = colnames(component_), nrow)
    weekly_data[[as.character(component_[1,]$id)]] <-  dplyr::rename(weekly_data[[as.character(component_[1,]$id)]], amount = V1)
  }
  weekly_data
}