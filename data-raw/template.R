## code to prepare `template` dataset goes here

library(dplyr)

template <- readRDS(file.path("data-raw", "template.rds"))
usethis::use_data(template, overwrite = TRUE)

match_current_format <- function(template){
  # update to match current handwriter format
  template$template_graphs <- NULL
  template$graphs_seed <- NULL
  template$seed <- template$centers_seed
  template$centers_seed <- NULL
  template$rmse <- NULL
  template$DaviesBouldinIndex <- NULL
  template$VarianceRatioCriterion <- NULL
  template$numstrat <- NULL
  return(template)
}

make_docname_lookup <- function(template){
  # create lookup table with cvl docnames changed to be same length as csafe
  docnames <- unique(template$docnames)
  cvl <- data.frame("original"=docnames[grepl("^0+|^1+", docnames)])
  cvl$new <- paste0("c", cvl$original)
  cvl$new <- stringr::str_replace(cvl$new, "-1-cropped", "_abbotflatlnd")

  # add csafe to lookup table. csafe docnames don't require any changes
  csafe <- data.frame("original"=docnames[!grepl("^0+|^1+", docnames)])
  csafe$new <- csafe$original

  # make lookup table
  lookup <- rbind(cvl, csafe)
  return(lookup)
}

find_new_docname <- function(lookup, docname){
  new <- lookup %>% dplyr::filter(original == docname) %>% pull(new)
  return(new)
}

fix_docnames <- function(template){
  lookup <- make_docname_lookup(template)

  docnames <- template$docnames

  new <- sapply(docnames, function(docname) find_new_docname(lookup, docname), USE.NAMES = FALSE)

  return(new)
}

fix_docnames_and_writers <- function(template) {
  template$docnames <- fix_docnames(template)
  template$writers <- substr(template$docnames, 1, 5)
  return(template)
}

template <- match_current_format(template)
template <- fix_docnames_and_writers(template)

usethis::use_data(template, overwrite = TRUE)
