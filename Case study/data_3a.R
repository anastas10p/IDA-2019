separate_by_year <- function(components_list){
  
  yearly_data <- vector(mode="list", length=9)
  names(yearly_data) <- sprintf("%d", seq(from=2008, to=2016))
  years <- c(2008:2016)
  for (year_ in names(yearly_data)){
    yearly_data[[year_]] <- tibble(id=as.character(),
                                   factory=as.numeric(),
                                   production_year=as.numeric(),
                                   absolute_error_frequency=as.numeric(),
                                   relative_error_frequency=as.numeric())
  }
  for(component in components_list){
    for (year_ in years){
      for (factory_ in levels(component$factory)){
        factory_year <- subset(component, component$production_year==year_)
        abs_f_r <- sum(with(factory_year, faulty == TRUE))
        rel_f_r <- sum(with(factory_year, faulty == TRUE))/nrow(factory_year)
        yearly_data[[as.character(year_)]] <- 
          add_row(yearly_data[[as.character(year_)]],
                id=component$id[1],
                factory=factory_,
                production_year=year_,
                absolute_error_frequency=abs_f_r,
                relative_error_frequency=rel_f_r)
      } 
    }
  }
  yearly_data
}