# Randomly select 100 CSAFE Handwriting Database London Letters for training a
# cluster template

library(dplyr)

main_dir <- "/Users/stephanie/Documents/handwriting_datasets/CSAFE_Handwriting_Database"
template_docs <- "data-raw/template_docs"

# make data frame
df <- data.frame("folder" = list.files(main_dir, full.names = TRUE))
df$writer <- basename(df$folder)

# select 100 writers for template training
set.seed(10)
df <- df %>% dplyr::slice_sample(n=100, replace = FALSE)

# get London Letters from first 50 writers and Wizard of Oz from the other 50
df$doc <- rep(NA, 50)
df$doc[1:50] <- file.path(main_dir, df$writer, paste0(df$writer, "_s01_pLND_r01.png"))[1:50]
df$doc[51:100] <- file.path(main_dir, df$writer, paste0(df$writer, "_s01_pWOZ_r01.png"))[51:100]

# format file path for template_docs folder
df$template_doc <- file.path(template_docs, basename(df$doc))

df$template_doc[]

# copy training docs to extdata
file.copy(df$doc, df$template_doc)
