# Install libraries

# Function to check and install missing packages
install_and_load <- function(packages) {
  # Identify missing packages
  missing_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  
  # Install missing packages
  if (length(missing_packages) > 0) {
    message("Installing missing packages: ", paste(missing_packages, collapse = ", "))
    install.packages(missing_packages, dependencies = TRUE)
  }
  
  # Load all packages
  invisible(lapply(packages, function(pkg) {
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }))
}

# List of required packages
required_packages <- c("rmarkdown", "targets", "tidyverse", "openai", "ellmer", "palmerpenguins", "summarytools", "viridis", "ggthemes", "gt", "gtsummary", "e1071", "ggthemes", "flextable", "scales", "viridis")

# Run function
install_and_load(required_packages)
