# Randomly select 100 CSAFE Handwriting Database London Letters for training a
# cluster template

library(dplyr)

main_dir <- "/Users/stephanie/Documents/handwriting_datasets/CSAFE_Handwriting_Database"
template_docs <- "data-raw/template_docs"

# make data frame
df <- data.frame("folder" = list.files(main_dir, full.names = TRUE))
df$writer <- basename(df$folder)
df$doc <- file.path(main_dir, df$writer, paste0(df$writer, "_s01_pLND_r01.png"))
df$template_doc <- file.path(template_docs, paste0(df$writer, "_s01_pLND_r01.png"))

# select writers for template training
set.seed(100)
df <- df %>% dplyr::slice_sample(n=100, replace = FALSE)

# copy training docs to extdata
file.copy(df$doc, df$template_doc)
