# officer demo

library(officer)
library(readr)
library(dplyr)
library(gtsummary)
library(e1071)
library(ggplot2)
library(ggthemes)
library(flextable)
library(scales)

# read titanic dataset
titanic_df <- read_csv("titanic_short.csv")

# read a blank powerpoint or a template
my_pres <- read_pptx("canva_template.pptx") 

# check available layouts
layout_summary(my_pres)

# check available objects
layout_properties (x = my_pres, layout = "title_page")

## add title and author to the first slide
my_pres <- on_slide(my_pres, index = 1) %>%
  ph_with(value = "Titanic Data Analysis", location = ph_location_label( "title")) %>%
  ph_with(value = "Ashutosh Nandeshwar", location = ph_location_label( "authors"))

# check available objects
layout_properties (x = my_pres, layout = "text_photo")

## add title and author to the second slide
slide_2_tbl <- titanic_df %>% 
  filter(survived == 0) %>% 
  count(pclass) %>%
  mutate(dist = n/sum(n)) %>%
  mutate(text = paste("Class", pclass, ":", scales::percent(dist)))

slide_2_text <- paste(slide_2_tbl$text, collapse = ", ")

my_pres <- on_slide(my_pres, index = 2) %>%
  ph_with(value = "Relationship between cabin class and survival", location = ph_location_label( "title")) %>%
  ph_with(value = paste("Death rate by class", slide_2_text),
          location = ph_location_label( "content"))

# check available objects
layout_properties (x = my_pres, layout = "side_by_side_charts")

slide_3_left_side_chart <- titanic_df %>%
  ggplot(aes(x = pclass, fill = as.factor(survived))) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("0" = "#C86653", "1" = "#eedbac")) +
  theme_few() +
  theme(legend.position = "bottom")

slide_3_left_side_text <- "Cabin class 3 suffered the most loss of life."

mod1 <- lm(survived ~ pclass + sex, data =  titanic_df)

tbl_reg_t1 <- tbl_regression(mod1, intercept = TRUE)

# convert the equation to text
# https://stackoverflow.com/a/64376355
get_reg_text_formula <- function(model) {
  
  broom::tidy(model)[, 1:2] %>%
    mutate(sign = ifelse(sign(estimate) == 1, ' + ', ' - ')) %>% #coeff signs
    mutate_if(is.numeric, ~ abs(round(., 2))) %>% #for improving formatting
    mutate(a = ifelse(term == '(Intercept)', paste0('y ~ ', estimate), paste0(sign, estimate, ' * ', term))) %>%
    summarise(formula = paste(a, collapse = '')) %>%
    as.character
}

linear_eq_text <- get_reg_text_formula(mod1)


slide_3_right_side_chart <-  tbl_reg_t1 %>% as_flex_table() %>%  width(width = 1.5)
slide_3_right_side_text <- linear_eq_text

my_pres <- on_slide(my_pres, index = 3) %>%
  ph_with(value = slide_3_left_side_chart, location = ph_location_label( "left_side_chart")) %>%
  ph_with(value = slide_3_left_side_text, location = ph_location_label( "left_side_text")) %>%
  ph_with(value = slide_3_right_side_chart, location = ph_location_label( "right_side_chart")) %>%
  ph_with(value = slide_3_right_side_text, location = ph_location_label( "right_side_text"))

# objects for slide 4
nu_passengers <- nrow(titanic_df)
pct_survived <- percent(nrow(titanic_df %>% filter(survived == 1)) / nu_passengers)
avg_age <- number(mean(titanic_df$age, na.rm = TRUE), accuracy = 0.01)

  
my_pres <- on_slide(my_pres, index = 4) %>%
  ph_with(value = nu_passengers, location = ph_location_label("bottom_text_1")) %>%
  ph_with(value = pct_survived, location = ph_location_label("bottom_text_2")) %>%
  ph_with(value = avg_age, location = ph_location_label("bottom_text_3"))

# save the powerpoint
print(my_pres, target = "ppt_reports/my_canva_presentation.pptx") 

