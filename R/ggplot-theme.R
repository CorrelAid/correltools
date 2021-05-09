#' ggplot theme based on CorrelAid design guide
#'
#' A theme following the [CorrelAid design guide](https://docs.correlaid.org/wiki/design-guide).
#'
#' Uses the font family [Roboto](https://fonts.google.com/specimen/Roboto).
#' If Roboto is not installed, the system's default (sans-serif) font is used.
#'
#' @param base_size `numeric` Base font size, given in pts
#' @param grid `character` Panel grid ("none" or a combination of X, x, Y, y)
#'
#' @return An object of class `theme`
#' @export
#'
#' @examples
#' library(ggplot2)
#'
#' ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_correlaid()
theme_correlaid <- function(base_size = 14, grid = "XY") {
  if (length(grid) != 1 || !grepl("none|X|Y|x|y", grid)) {
    stop('`grid` must be a string: "none" or any combination of "X", "Y", "x", and "y"')
  }

  if (sum(grepl("^Roboto$", systemfonts::system_fonts()$family)) > 0) {
    base_family <- "Roboto"
  } else {
    base_family <- ""
    message("Roboto font not installed. Using system's default font.")
  }

  colours <- list(
    grey = "#3c3c3b",
    grey75 = "#727375",
    grey25 = "#cdced0"
  )

  ret <- ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      text = ggplot2::element_text(family = base_family, colour = colours$grey),
      line = ggplot2::element_line(colour = colours$grey25),
      plot.title = ggplot2::element_text(
        face = "bold", color = colours$grey, size = ggplot2::rel(1.5),
        margin = ggplot2::margin(t = 0, b = base_size * 2 / 3),
      ),
      plot.subtitle = ggplot2::element_text(
        lineheight = 1.2,
        margin = ggplot2::margin(t = 0, b = base_size)
      ),
      axis.title.x = ggplot2::element_text(
        face = "bold",
        colour = colours$grey75,
        margin = ggplot2::margin(t = base_size * 2 / 3, r = 0, b = 0, l = 0)
      ),
      axis.title.y = ggplot2::element_text(
        face = "bold",
        colour = colours$grey75,
        margin = ggplot2::margin(t = 0, r = base_size * 2 / 3, b = 0, l = 0)
      ),
      axis.text.x = ggplot2::element_text(
        colour = colours$grey75,
        margin = ggplot2::margin(t = base_size / 3, r = 0, b = 0, l = 0)
      ),
      axis.text.y = ggplot2::element_text(
        colour = colours$grey75,
        margin = ggplot2::margin(t = 0, r = base_size / 3, b = 0, l = 0)
      ),
      legend.title = ggplot2::element_text(
        face = "bold",
        colour = colours$grey75
      ),
      legend.position = "top",
      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(size = ggplot2::rel(1.05)),
      panel.grid.major = ggplot2::element_line(size = .35),
      panel.grid.minor = ggplot2::element_line(size = .35),
      panel.background = ggplot2::element_rect(
        fill = "transparent", colour = "transparent"
      ),
      plot.background = ggplot2::element_rect(
        fill = "transparent", colour = "transparent"
      ),
      plot.margin = ggplot2::margin(
        t = base_size * 1.4, r = base_size * 1.4,
        b = base_size * 1.4, l = base_size * 1.4
      ),
      plot.title.position = "plot",
      plot.caption.position = "plot"
    )

  if (!grepl("X", grid)) {
    ret <- ret + ggplot2::theme(panel.grid.major.x = ggplot2::element_blank())
  }
  if (!grepl("Y", grid)) {
    ret <- ret + ggplot2::theme(panel.grid.major.y = ggplot2::element_blank())
  }
  if (!grepl("x", grid)) {
    ret <- ret + ggplot2::theme(panel.grid.minor.x = ggplot2::element_blank())
  }
  if (!grepl("y", grid)) {
    ret <- ret + ggplot2::theme(panel.grid.minor.y = ggplot2::element_blank())
  }

  ret
}