#' correlaidx_map
#' @param chapters_df tibble. tibble with all local chapters. best obtained through get_correlaidx_data()
#' @param lang character. language of the map. either 'en' or 'de'
#' @description returns a widget that shows correlaidx chapters on a map.
#' @import leaflet
#' @importFrom rlang .data
#' @export
correlaidx_map <- function(chapters_df, lang = 'en') {

  if (!lang %in% c('de', 'en')) {
    stop("lang needs to be either 'de' or 'en'")
  }
  countries_sf <-
    rnaturalearth::ne_countries(continent = 'europe',
                                scale = "large", returnclass = "sf") %>%
    sf::st_set_crs(4326) %>%
    dplyr::filter(.data$su_a3 %in% unique(chapters_df$iso_a3))

  #define color palette
  correlaidx_pal <- correltools::correlaid_pal(option = 'gradient_x')
  year_founded <- factor(chapters_df$year_founded)
  pal_cities <- leaflet::colorFactor(correlaidx_pal(length(year_founded)), domain = year_founded)

  cax_map <-

    leaflet() %>%

    addProviderTiles(
      providers$CartoDB.Positron,
      options = providerTileOptions(opacity = 0.7)
    ) %>%

    addPolygons(
      data = countries_sf,
      fillColor = '#BA5E75',
      fillOpacity = .2,
      stroke = FALSE
    ) %>%

    addCircles(
      data = chapters_df,
      color = ~pal_cities(factor(year_founded)),
      fillOpacity = .8,
      radius = 12000,
      highlightOptions = highlightOptions(
        color = "white",
        bringToFront = TRUE
      ),
      popup = ~glue::glue("<b>CorrelaidX {chapter}</b><br/>",
                    "&#128279;<a href='{url}'>Info</a>")
    ) %>%

    addLegend(
      data = chapters_df,
      "bottomright",
      pal = pal_cities,
      values = ~factor(year_founded),
      title = ifelse(lang == 'en', "Year founded", "Gründungsjahr"),
      opacity = 1
    ) %>%

    setView(lng = 5.5, lat = 49.5, zoom = 5)
  cax_map
}


#'crawl_correlaidx_data
#'@param lang character. language to crawl chapters for. either 'de' or 'en'. defaults to 'en'
#'@description crawls lc-chapters from the CorrelAid website with package rvest
#'@importFrom rlang .data
crawl_correlaidx_data <- function(lang = 'en') {
  base_url <- 'https://correlaid.org/'
  if (lang == 'de') {
    base_url <- paste0(base_url, 'de')
  }
  h <- xml2::read_html(
    base_url
  )

  # lc-names
  lc_nodes <- h %>%
    rvest::html_nodes("a.nav-item.nav-link.active")


  # extract urls and names
  lc_names <- lc_nodes %>% rvest::html_text()
  lc_urls <- lc_nodes %>%
    rvest::html_attr("href")


  # data frame
  lc <- tibble::tibble(chapter = lc_names, url = lc_urls) %>%
    dplyr::filter(!grepl("\\n", .data$chapter)) %>%
    dplyr::distinct()
  lc
}

#'get_correlaidx_data
#'@param lang character. language to get chapters for. either 'de' or 'en'. defaults to 'en'
#'@description gets data for local chapters by crawling the names from the navbar of the CorrelAid website and then geocoding the cities.
#'also adds information on when the chapter was founded from the package dataset \code{\link{local_chapters_year_founded}}
#'@importFrom rlang .data
#'@export
get_correlaidx_data <- function(lang = 'en') {
  if (!lang %in% c('de', 'en')) {
    stop("lang needs to be either 'de' or 'en'")
  }

  # get from website
  website_df <- crawl_correlaidx_data(lang)

  #geocoding the cities
  countries <- rnaturalearth::ne_countries(returnclass = 'sf')
  message('geocoding - this can take a couple of seconds')
  geocoded_df <- tmaptools::geocode_OSM(website_df$chapter) %>%
    sf::st_as_sf(coords = c("lon", "lat"), remove = FALSE) %>%
    sf::st_set_crs(sf::st_crs(countries))

  # manual for rhein-main
  geocoded_df <- geocoded_df %>%
    dplyr::mutate(lat = dplyr::if_else(.data$query == 'Rhein-Main', 50.1, .data$lat),
                  lon = dplyr::if_else(.data$query == 'Rhein-Main', 8.7, .data$lon))

  # get the iso 3 country code for each point
  geocoded_df <- geocoded_df %>%
    dplyr::mutate(
      intersection = as.integer(sf::st_intersects(.data$geometry, rnaturalearth::ne_countries(returnclass = 'sf')))
      , iso_a3 = dplyr::if_else(is.na(.data$intersection), '', countries$iso_a3[.data$intersection])
    )

  # merge datasets
  chapters_df <- website_df %>%
    dplyr::left_join(geocoded_df, by = c('chapter' = 'query')) %>%
    dplyr::left_join(correltools::local_chapters_year_founded, by = c('chapter' = paste0('chapter_', lang)))

  # drop unnecessary variables
  chapters_df %>%
    dplyr::select(-.data$intersection, -dplyr::ends_with('max'), -dplyr::ends_with('min'))
}
