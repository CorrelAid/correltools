#' correlaidx_map
#' @param cities_df tibble. tibble with all local chapters. defaults to correltools::chapters_df
#' @param lang character. language of the map. either 'en' or 'de'
#' @description returns a widget that shows correlaidx chapters on a map. The input data frame needs specific variables for it
#' to work, check correltools::chapters_df to see an example.
correlaidx_map <- function(chapters_df = correltools::chapters_df, lang = 'en') {

  if (!lang %in% c('de', 'en')) {
    stop("lang needs to be either 'de' or 'en'")
  }

  countries_sf <-
    rnaturalearth::ne_countries(continent = 'europe',
                                scale = "large", returnclass = "sf") %>%
    st_set_crs(4326) %>%
    dplyr::filter(su_a3 %in% unique(chapters_df$iso3))

  #define color palette
  correlaidx_pal <- correltools::correlaid_pal(option = 'gradient_x')
  year_founded <- factor(chapters_df$year_founded)
  pal_cities <- colorFactor(correlaidx_pal(length(year_founded)), domain = year_founded)

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
      popup = ~glue("<b>CorrelaidX {chapter}</b><br/>",
                    "&#128279;<a href='{link}'>Info</a>")
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
