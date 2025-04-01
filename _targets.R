# _targets.R file
library(targets)

tar_source(files = "target_functions.R")

tar_option_set(packages = c("readr", "dplyr", "ggplot2", "e1071", "ggthemes"))

list(
  tar_target(file, "titanic_short.csv", format = "file"),
  tar_target(data, get_data(file))
  # , tar_target(prepped_data, prep_data(data))
  # , tar_target(model, fit_model(prepped_data))
  # , tar_target(predictions, predict_survival(model, prepped_data))
  # , tar_target(plot, create_plot(predictions))
)