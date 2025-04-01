# target_functions.R

get_data <- function(file) {
  readr::read_csv(file)
}

prep_data <- function(df){
  df %>% 
    mutate(
      survived = as.factor(survived), # convert to factor
      age = ifelse(is.na(age), mean(age, na.rm = TRUE), age) # impute missing values
      
    )
}

# build a naive bayes model
fit_model <- function(df){
  naiveBayes(survived ~ ., data = df)
}

# run predictions and add a new column
predict_survival <- function(model, df){
  df %>%
    mutate(
      prediction = predict(model, newdata = df, type = "class")
    )
}

# create a plot of predictions and actual by pclass and sex
create_plot <- function(df){
  df %>%
    ggplot(aes(x = pclass, fill = survived)) +
    geom_bar(position = "dodge") #+
    # facet_wrap(~sex)  + scale_fill_manual(values = c("0" = "#C86653", "1" = "#eedbac")) +
    # theme_few()
}
