#' CorrelAid theme for ggplot2
#'
#' A theme based on the [CorrelAid design guide](https://docs.correlaid.org/wiki/design-guide)
#'
#' Uses the font family [Roboto](https://fonts.google.com/specimen/Roboto).
#'   If Roboto is not installed, the system's default (sans-serif) font is used.
#'
#' @inheritParams ggplot2::theme_minimal
#' @param grid A string: panel grid ("none" or a combination of X, x, Y, y)
#'
#' @return A `theme` object
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(showtext)
#' showtext_auto() # Necessary for certain graphics devices to display the custom font
#'
#' ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_correlaid()
#'
#' ggplot(example_projects_labels, aes(category)) +
#'  geom_bar() +
#'  labs(title = "Title", subtitle = "Subtitle", caption = "Caption") +
#'  theme_correlaid() +
#'  add_correlaid_logo()
theme_correlaid <- function(base_size = 14,
                            base_family = "Roboto",
                            base_line_size = base_size / 28,
                            base_rect_size = base_size / 28,
                            grid = "XY") {
  if (length(grid) != 1 || !grepl("none|X|Y|x|y", grid)) {
    stop('`grid` must be a string: "none" or any combination of "X", "Y", "x", and "y"')
  }

  if (!(base_family %in% systemfonts::system_fonts()$family)) {
    message(base_family, " font not installed. Using system's default font.")
    base_family <- ""
  }

  ret <- ggplot2::theme_minimal(
    base_size = base_size,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  ) +
    ggplot2::theme(
      text = ggplot2::element_text(
        family = base_family,
        colour = correlaid_colours$grey[["grey90"]]
      ),
      line = ggplot2::element_line(colour = correlaid_colours$grey[["grey25"]]),
      plot.title = ggplot2::element_text(
        face = "bold",
        size = ggplot2::rel(1.5),
        margin = ggplot2::margin(b = base_size * 2 / 3),
      ),
      plot.subtitle = ggplot2::element_text(
        lineheight = 1.2,
        margin = ggplot2::margin(b = base_size)
      ),
      plot.caption = ggplot2::element_text(
        hjust = 0,
        margin = ggplot2::margin(t = base_size * 2 / 3)
      ),
      axis.title.x = ggplot2::element_text(
        face = "bold",
        colour = correlaid_colours$grey[["grey75"]],
        margin = ggplot2::margin(t = base_size * 2 / 3)
      ),
      axis.title.y = ggplot2::element_text(
        face = "bold",
        colour = correlaid_colours$grey[["grey75"]],
        margin = ggplot2::margin(r = base_size * 2 / 3)
      ),
      axis.text.x = ggplot2::element_text(
        colour = correlaid_colours$grey[["grey75"]],
        margin = ggplot2::margin(t = base_size / 3)
      ),
      axis.text.y = ggplot2::element_text(
        colour = correlaid_colours$grey[["grey75"]],
        margin = ggplot2::margin(r = base_size / 3)
      ),
      legend.key.size = grid::unit(base_size * 1.1, "pt"),
      legend.title = ggplot2::element_text(
        face = "bold",
        colour = correlaid_colours$grey[["grey75"]],
        vjust = grid::unit(1, "npc") - grid::unit(base_size / 14, "pt")
      ),
      legend.text = ggplot2::element_text(colour = correlaid_colours$grey[["grey75"]]),
      legend.position = "top",
      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(size = ggplot2::rel(1.05)),
      panel.grid.major = ggplot2::element_line(size = ggplot2::rel(.7)),
      panel.grid.minor = ggplot2::element_line(size = ggplot2::rel(.7)),
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
