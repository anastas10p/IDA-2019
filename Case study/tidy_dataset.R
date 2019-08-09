tidy_dataset <- function(component_data){
  
  #Drop the columns that do not interest us.
  component_data <- select(component_data, -c(starts_with("Hersteller"),
                                              starts_with("Werks"),
                                              #ends_with("Fahrleistung"),
                                              starts_with("X")))
  #ID:
  for (id_column in colnames(select(component_data, starts_with("ID")))){
    component_data[[id_column]] <- as.character(component_data[[id_column]])
  }
  
  #Fehlerhaft
  for (faulty_column in colnames(select(component_data, starts_with("Fehlerhaft")))){
    if (startsWith(faulty_column, "Fehlerhaft_Datum")) {
      component_data[[faulty_column]] <- as.Date(component_data[[faulty_column]], format="%Y-%m-%d")    
    } else if (startsWith(faulty_column, "Fehlerhaft_Fahrleistung")){
      component_data[[faulty_column]] <- as.numeric(component_data[[faulty_column]])
    } else
    component_data[[faulty_column]] <- as.logical(component_data[[faulty_column]])
  }
  #Produktionsatum
  #If the date is set as an origin date:
  if ("origin" %in% colnames(component_data)){
    for (production_date_column in colnames(select(component_data, starts_with("Produktionsdatum")))){
      component_data[[paste("Produktionsdatum", 
                            ifelse(is.na(strsplit(production_date_column, ".", fixed = TRUE)[[1]][2]),
                                   "", paste(".",strsplit(production_date_column, sep=".", fixed = TRUE)[[1]][2])),
                            sep="")]] <- 
        as.Date(component_data[[production_date_column]], origin = "1970-01-01")
    }
  } else {
    for (production_date_column in colnames(select(component_data, starts_with("Produktionsdatum")))){
      component_data[[production_date_column]] <- as.Date(component_data[[production_date_column]], format="%Y-%m-%d")
    }
  }
  
  #Create new clean columns
  #These commands are kept separate for readability's sake.
  
  id_cols <- Filter(Negate(function(x) is.null(unlist(x))), 
                    list(try(component_data[[colnames(select(component_data, starts_with("ID")))[1]]]), 
                         try(component_data[[colnames(select(component_data, starts_with("ID")))[2]]]),
                         try(component_data[[colnames(select(component_data, starts_with("ID")))[3]]])))
  component_data$id <- coalesce(!!!id_cols)
  
  production_date_cols <- Filter(Negate(function(x) is.null(unlist(x))), 
                      list(try(component_data$Produktionsdatum), 
                           try(component_data$Produktionsdatum.x),
                           try(component_data$Produktionsdatum.y)))
  component_data$production_date <- coalesce(!!!production_date_cols)
  
  faulty_date_cols <- Filter(Negate(function(x) is.null(unlist(x))), 
                                 list(try(component_data$Fehlerhaft_Datum), 
                                      try(component_data$Fehlerhaft_Datum.x),
                                      try(component_data$Fehlerhaft_Datum.y)))
  component_data$faulty_date <- coalesce(!!!faulty_date_cols)
  
  distance_cols <-  Filter(Negate(function(x) is.null(unlist(x))), 
                           list(try(component_data$Fehlerhaft_Fahrleistung), 
                                try(component_data$Fehlerhaft_Fahrleistung.x),
                                try(component_data$Fehlerhaft_Fahrleistung.y)))
  component_data$distance <- coalesce(!!!distance_cols)
  
  faulty_cols <- Filter(Negate(function(x) is.null(unlist(x))), 
                        list(try(component_data$Fehlerhaft), 
                             try(component_data$Fehlerhaft.x), 
                             try(component_data$Fehlerhaft.y)))
  component_data$faulty <- coalesce(!!!faulty_cols)
  
  #Fill the producer and factory column using the id data.
  component_data_clean <- component_data %>%
    separate(id, c("id", "producer", "factory", "number"), "-") %>%
    select(c("id", "producer", "factory",  "faulty", "production_date", "faulty_date", "distance"))
  rm(component_data)
  
  component_data_clean$id <- as.factor(component_data_clean$id)
  component_data_clean$producer <- as.factor(component_data_clean$producer)
  component_data_clean$factory <- as.factor(component_data_clean$factory)
  
  distinct(component_data_clean)
}