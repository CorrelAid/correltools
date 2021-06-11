#' correlaidx_map
#' @param cities_df tibble. tibble with all local chapters. defaults to correltools::chapters_df
#' @param lang character. language of the map. either 'en' or 'de'
#' @description returns a widget that shows correlaidx chapters on a map. The input data frame needs specific variables for it
#' to work, check correltools::chapters_df to see an example.
correlaidx_map <- function(chapters_df = correltools::chapters_df, lang = 'en') {

  if (!lang %in% c('de', 'en')) {
    stop("lang needs to be either 'de' or 'en'")
  }

  # define palettes
  correlaid_colours <- list(
    gradient = c(
      "#bcd259",
      "#96c246",
      "#78a972",
      "#6fa080",
      "#508994",
      "#3665a3",
      "#3c61aa",
      "#2d3b5a"
    ),
    gradient_x = c(
      "#f04451",
      "#e35564",
      "#b65976",
      "#906289",
      "#7b6490",
      "#5b669d",
      "#3665a3",
      "#254e90"
    )
  )

  countries_sf <-
    rnaturalearth::ne_countries(country = c("Germany", "Netherlands", "France", "Switzerland"),
                                scale = "large", returnclass = "sf") %>%
    st_set_crs(4326)

  pal_cities <- colorFactor(correlaid_colors$gradient, domain = factor(chapters_df$year_founded))

  pal_cntrs <- colorFactor(correlaid_colors$gradient_x, domain = factor(chapters_df$year_founded))
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
      color = ~pal_cntrs(factor(year_founded)),
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
      pal = pal_cntrs,
      values = ~factor(year_founded),
      title = ifelse(lang == 'en', "Year founded", "Gründungsjahr"),
      opacity = 1
    ) %>%

    setView(lng = 5.5, lat = 49.5, zoom = 5)
  cax_map
}
