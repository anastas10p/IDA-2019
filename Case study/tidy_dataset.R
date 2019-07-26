tidy_dataset <- function(component_data){
  
  #Drop the columns that do not interest us.
  component_data <- select(component_data, -c(starts_with("Fehlerhaft_"), starts_with("X")))
  #str(component_data)
  #ID:
  for (id_column in colnames(select(component_data, starts_with("ID")))){
    component_data[[id_column]] <- as.character(component_data[[id_column]])
  }
  #Herstellernummer
  for (producer_column in colnames(select(component_data, starts_with("Herstellernummer")))){
    component_data[[producer_column]] <- as.integer(component_data[[producer_column]])
  }
  #Werksnummer
  for (factory_column in colnames(select(component_data, starts_with("Werksnummer")))){
    component_data[[factory_column]] <- as.integer(component_data[[factory_column]])
  }
  #Fehlerhaft
  for (faulty_column in colnames(select(component_data, starts_with("Fehlerhaft")))){
    component_data[[faulty_column]] <- as.logical(component_data[[faulty_column]])
  }
  #Datum
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
  
  producer_cols <- Filter(Negate(function(x) is.null(unlist(x))), 
                          list(try(component_data$Herstellernummer), 
                               try(component_data$Herstellernummer.x), 
                               try(component_data$Herstellernummer.y)))
  component_data$producer_number <- coalesce(!!!producer_cols)
  
  factory_cols <- Filter(Negate(function(x) is.null(unlist(x))), 
                         list(try(component_data$Werksnummer), 
                              try(component_data$Werksnummer.x), 
                              try(component_data$Werksnummer.y)))
  component_data$factory_number <- coalesce(!!!factory_cols)
  
  date_cols <- Filter(Negate(function(x) is.null(unlist(x))), 
                      list(try(component_data$Produktionsdatum), 
                           try(component_data$Produktionsdatum.x),
                           try(component_data$Produktionsdatum.y)))
  component_data$production_date <- coalesce(!!!date_cols)
  
  faulty_cols <- Filter(Negate(function(x) is.null(unlist(x))), 
                        list(try(component_data$Fehlerhaft), 
                             try(component_data$Fehlerhaft.x), 
                             try(component_data$Fehlerhaft.y)))
  component_data$faulty <- coalesce(!!!faulty_cols)
  
  
  #Select the new columns and delete the old data to save memory.
  component_data_clean <- select(component_data, "id", "producer_number", "factory_number", "faulty", "production_date")
  rm(component_data)
  
  #Check the clean data for mistakes by comparing the data in the id with the corresponding columns.
  split_ids <- str_split(string = component_data_clean$id, pattern = "-")
  
  #To be subbed with something without a loop.
  for(entry_nr in c(1:nrow(component_data_clean))){
    
    id_split <- str_split(test_table[entry_nr, ])
    id_producer <- id_split[2]
    id_factory <- id_split[3]
    
    #Check producer
    if(component_data_clean$producer[entry_nr] != id_producer){
      #Print message and correct
      print(paste("Correcting entry's", component_data_clean$id[entry_nr],
                  "producer number from", component_data_clean$producer[entry_nr],
                  "to the id information", id_producer))
      component_data_clean$producer[entry_nr] <- id_producer
    }
    
    #Check factory
    if(component_data_clean$dactroy[entry_nr] != id_factory){
      #Print message and correct
      print(paste("Correcting entry's", component_data_clean$id[entry_nr],
                  "factory number from", component_data_clean$factory[entry_nr],
                  "to the id information", id_factory))
      component_data_clean$factory[entry_nr] <- id_factory
    }
  }
}