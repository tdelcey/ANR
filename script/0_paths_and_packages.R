package_list <- c("here", # building clearer paths
                  "tidyverse",
                  "pdftools",
                  "data.table",
                  "janitor", # cleaning column names of import csv
                  "arrow", # compressing large data base
                  "qdapDictionaries",
                  "tidytext",
                  "stringi", 
                  "stringdist", 
                  "reshape2", 
                  "spacyr", 
                  "splitstackshape",
                  "quanteda",
                  "dplyr", 
                  "dtplyr", 
                  "janitor",
                  "tidygraph",
                  "networkflow", 
                  "ggplot2", 
                  "readxl", 
                  "gender")

for (p in package_list) {
  if (p %in% installed.packages() == FALSE) {
    install.packages(p, dependencies = TRUE)
  }
  library(p, character.only = TRUE)
}

#' We create a path to the repository where the .txt created from the initial
#' pdf are stored, and we create a list of all the .txt names, to be used later for 
#' text extraction. 
#' 
#' For the path, we distinguish the path for Aurélien, Thomas and Alex.

if(str_detect(getwd(), "thomd")){
  data_path <- "C:/Users/thomd/Documents/MEGA/github/ANR/data/"
} else {
  if(str_detect(getwd(), "thomd")) {
    data_path <- "path_"
  } else {
    data_path <- "path_"
  }
}




