correlaid_colours <- list(
  qualitative = c(
    green = "#96c342",
    blue = "#3863a2",
    red = "#f04451"
  ),
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
