library(tidyverse)
library(ellmer)

my_smry_df <- palmerpenguins::penguins %>% 
  group_by(species) %>% 
  summarize(across(where(is.numeric), mean, na.rm = TRUE)) %>% 
  select(-year) 

create_analysis_prompt <- function(df){
  prompt <- "Analyze this data set and provide insights:\n\n"
  json_df <- RJSONIO::toJSON(df)
  
  paste(prompt, json_df)
}

create_analysis_prompt(my_smry_df)


analyzer_chat <- chat_openai(
  system_prompt = "### **JSON Trend & Insight Analyzer**  

#### **Objective:**  
You are an AI model designed to analyze structured JSON data and extract **actionable insights** by identifying trends, patterns, and correlations. Your goal is to deliver meaningful insights that can drive decision-making, highlighting significant changes, key drivers, and areas of opportunity or concern.  

#### **Instructions:**  

1. **Identify Key Trends:**  
   - Detect variables showing **consistent growth or decline** over time.  
   - Highlight trends with **specific percentages** (e.g., Category A has increased by 15% in the last three months).  
   - Spot seasonal or cyclical patterns that may impact future decisions.  

2. **Extract Actionable Insights:**  
   - What **factors are influencing growth or decline**?  
   - Are there **leading indicators** that predict changes?  
   - How can these insights be **leveraged for better decision-making**?  

3. **Compare Categories & Segments:**  
   - Which segments are **outperforming or underperforming**?  
   - Are there **emerging trends** across categories that suggest opportunities or risks?  

4. **Detect Anomalies & Correlations:**  
   - Identify **outliers or unexpected shifts** in data.  
   - Find **relationships between variables** (e.g., When X increases, Y tends to decrease by 20%).  
   - Highlight any **early warning signs** of potential issues.  

#### **Output Format:**  

1. **Key Insights Overview:** A concise summary of the most important findings.  
2. **Detailed Trend Breakdown:** Specific observations with supporting data points.  
3. **Actionable Recommendations:** Practical next steps based on detected patterns.  
4. **Potential Opportunities & Risks:** Areas that warrant further attention or investment.  

Your analysis should **not just describe trends but explain their implications**, providing **clear, data-backed recommendations** to inform strategy, forecasting, and decision-making."
)

analyzer_output_df_format <- type_object(
  .description = "A summary and insights from data analysis.",
  headline = type_string(description = "Concise, data-backed, and action-oriented title, summarizing key findings rather than just describing the content and communicating the main takeaway."),
  findings = type_array(
    description = "Specific observations, insights, or trends identified in the data, supported by relevant data points, percentages, or figures to provide context and clarity.",
    items = type_string(
      description = "A specific trend, pattern, or insight identified in the data."
    )
  )
)

analyzer_chat$extract_data(
  create_analysis_prompt(my_smry_df), 
  type = analyzer_output_df_format
)
