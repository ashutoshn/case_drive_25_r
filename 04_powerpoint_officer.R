# officer demo

library(officer)
library(readr)
library(dplyr)
library(gtsummary)
library(e1071)
library(ggplot2)
library(ggthemes)
library(flextable)

# read titanic dataset
titanic_df <- read_csv("titanic_short.csv")

# read a blank powerpoint or a template
my_pres <- read_pptx() 

# add a default layout slide
my_pres <- add_slide(my_pres, layout = "Title and Content", master = "Office Theme")
# add content to the title and body
my_pres <- ph_with(my_pres, value = "Titanic Data Analysis", location = ph_location_type(type = "title"))
my_pres <- ph_with(my_pres, 
                   value = head(titanic_df), 
                   location = ph_location_type(type = "body")) 

# add another slide
my_pres <- add_slide(my_pres, layout = "Title and Content") 
# add content to a placeholder label
my_pres <- ph_with(my_pres,  
                   value = as_flextable(summarizor(titanic_df, by = "survived")), 
                  location = ph_location_label(
                    ph_label = "Content Placeholder 2") )

# add a two column layout
my_pres <- add_slide(my_pres, layout = "Two Content")
# add content to the left and right placeholders
left_chart <-   titanic_df %>%
  ggplot(aes(x = pclass, fill = as.factor(survived))) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("0" = "#C86653", "1" = "#eedbac")) +
   theme_few() +
  theme(legend.position = "bottom")

right_chart <-   titanic_df %>%
  ggplot(aes(x = sex, fill = as.factor(survived))) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("0" = "#C86653", "1" = "#eedbac")) +
  theme_few() +
  theme(legend.position = "bottom")

my_pres <- ph_with(my_pres, 
                   value = left_chart, 
                  location = ph_location_left())
my_pres <- ph_with(my_pres, 
                   value = right_chart, 
                  location = ph_location_right()) 

# save the powerpoint
print(my_pres, target = "ppt_reports/my_presentation.pptx") 

