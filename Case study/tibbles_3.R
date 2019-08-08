#Clean the spaghetti up
years <- list(2008)#:2016)
filtered_comp_year <- list()
#Go through the factories
for (factory_ in unique(allComponents$factory)){
  #Initializing new dataframe
  factory_tibble <- tibble()
  #Go through the years
  #for (year_ in years){#} unique(lubridate::year(allComponents$production_date))){
  factory_year <- subset(allComponents,
                         factory == factory_ )#&
  #lubridate::year(allComponents$production_date) == as.character(year_))
  factory_tibble <- as_tibble(rbind(factory_tibble, factory_year))
  #  }
  filtered_comp_year[[length(filtered_comp_year) + 1]] <- as_tibble(factory_tibble)
}


final_tibble <- tibble(id=as.character(),
                       factory=as.character(),
                       production_year=as.numeric(),
                       absolute_error_frequency=as.numeric(),
                       relative_error_frequency=as.numeric())

# tibble_for_a <- tibble()
for (factory_ in filtered_comp_year){
  for (year_ in unique(lubridate::year(factory_$production_date))){
    factory_year <- subset(factory_, lubridate::year(factory_$production_date)==year_)
    for (id_ in unique(factory_year$id)){
      abs_f_r <- sum(with(factory_year, id == id_ & faulty == TRUE))
      rel_f_r <- sum(with(factory_year, id == id_ & faulty == TRUE))/sum(with(factory_year, id == id_))
      final_tibble <- add_row(final_tibble,
                              id = id_,
                              factory = unique(factory_$factory),
                              absolute_error_frequency = abs_f_r,
                              relative_error_frequency = rel_f_r,
                              production_year = year_)
    }
  }
}