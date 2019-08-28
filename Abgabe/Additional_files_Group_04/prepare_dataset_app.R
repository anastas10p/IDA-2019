library(tidyverse)

#dataframes for app
errors_by_id <- component_tibbles
for (component in 1:length(errors_by_id)){
  errors_by_id[[component]] <- errors_by_id[[component]] %>%
    group_by(id, producer, factory, production_year) %>%
    summarise(abs_error = sum(faulty, na.rm = TRUE), rel_error = abs_error/length(id))
}
errors_by_id <- bind_rows(errors_by_id)

errors_by_factory <- bind_rows(component_tibbles) %>%
  group_by(factory, production_year) %>%
  summarise(abs_error = sum(faulty, na.rm = TRUE), rel_error = abs_error/length(id))

errors_by_id_week <- component_tibbles
for (component in 1:length(errors_by_id_week)){
  errors_by_id_week[[component]] <- errors_by_id_week[[component]] %>%
    group_by(factory, production_year, production_week) %>%
    summarise(abs_error = sum(faulty, na.rm = TRUE), rel_error = abs_error/length(id)) %>%
    group_by(production_year, production_week) %>%
    mutate(total_error = sum(abs_error))
}

save(errors_by_factory, errors_by_id, errors_by_id_week, file = "dataset_app.RData")