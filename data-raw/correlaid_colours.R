correlaid_colours <- list(
  qualitative = c(
    green = "#96c342",
    blue = "#3863a2",
    red = "#f04451"
  ),
  gradient = c(
    "#bcd259",
    "#6fa07f",
    "#214f8f"
  ),
  gradient_x = c(
    "#f04451",
    "#85638c",
    "#214f8f"
  ),
  grey = c(
    grey90 = "#3c3c3b",
    grey75 = "#727375",
    grey50 = "#9e9fa3",
    grey25 = "#cdced0"
  )
)

correlaid_colors <- correlaid_colours

usethis::use_data(correlaid_colours, correlaid_colors, internal = TRUE, overwrite = TRUE)
