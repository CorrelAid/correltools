library(tidyverse)
library(tmaptools)
library(sf)
cities <- tibble(chapter = c("Berlin", "Dortmund", "Paris", "Mannheim", "Munich", "Bremen", "Stuttgart", "Hamburg", "Konstanz", "Nederland", "Rhein-Main",
                             "Cologne/Bonn", "Karlsruhe", "Hannover/Braunschweig", "Leipzig", "Switzerland"),
                 city_geo = c("Berlin", "Dortmund", "Paris", "Mannheim", "Munich", "Bremen", "Stuttgart", "Hamburg", "Konstanz", "Amsterdam", "Frankfurt",
                              "Cologne", "Karlsruhe", "Hannover", "Leipzig", "Zurich"),
                 label = c(2018, 2018, 2019, 2018, 2020, 2018, 2020, 2020, 2018, 2018, 2018, "coming soon?!", "coming soon?!", 2020, "coming soon?!", "coming soon?!"),
                 year_founded = c(2018, 2018, 2019, 2018, 2020, 2018, 2020, 2020, 2018, 2018, 2018, 2021, 2021, 2020, 2021, 2021))

geocoded <- tmaptools::geocode_OSM(cities$city_geo)

cities <- cities %>% left_join(geocoded, by = c("city_geo" = "query"))

example_correlaidx_geo <-
  cities %>%
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)

usethis::use_data(example_correlaidx_geo, overwrite = TRUE)
readr::write_csv(example_correlaidx_geo, "data/example_correlaidx_geo.csv")

