by_week <- function(components_list){
  
  yearly_data <- vector(mode="list", length=9)
  names(yearly_data) <- sprintf("%d", seq(from=2008, to=2016))
  
  component_names <- c("K1BE1", "K1BE2", "K1DI1", "K1DI2", "K2LE1",
                       "K2LE2", "K2ST1", "K2ST2",
                       "K3AG1", "K3AG2", "K3SG1", "K3SG2",
                       "K4", "K5", "K6", "K7")
  weekly_data <- vector(mode="list", length= 16)
  names(weekly_data) <- component_names
  
  for (component_ in components_list) {
    weekly_data[[as.character(component_[1,]$id)]] <- plyr::ddply(component_, .variables = colnames(component_), nrow)
    weekly_data[[as.character(component_[1,]$id)]] <-  dplyr::rename(weekly_data[[as.character(component_[1,]$id)]], amount = V1)
  }
  weekly_data
}