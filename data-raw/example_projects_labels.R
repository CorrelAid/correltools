## code to prepare `DATASET` dataset goes here
library(gh)
library(purrr)
library(dplyr)
library(tidyr)
username <- "correlaid"

# requires read access to correlaid/projects
projects <- gh::gh("GET /repos/correlaid/projects/issues", per_page = 100, state = "all")
projects_df <- tibble::tibble(number = projects %>% purrr::map_int("number"), state = projects %>% purrr::map_chr("state"))
projects_df <- projects_df %>%
  mutate(labels = projects %>% purrr::map("labels"))

example_projects_labels <- tidyr::unnest(projects_df, labels) %>%
  tidyr::unnest_wider(labels) %>%
  tidyr::separate(name, c("category", "value"), extra = "merge", fill = "right")

usethis::use_data(example_projects_labels, overwrite = TRUE)
readr::write_csv(example_projects_labels, "data/example_projects_labels.csv")
