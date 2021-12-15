#' Add CorrelAid logo
#'
#' Inset CorrelAid logo to the bottom right corner of a ggplot.
#'
#' The size of the logo is determined by the base text size set e.g. by
#'   the `base_size` argument in `theme_*()` functions.
#'
#' Adding the logo to a plot makes it a [`patchwork`][patchwork-package] object.
#'   Using the `+` operator e.g. to change the theme or scales after adding the
#'   logo would therefore have no effect. See example below and the
#'   [patchwork documentation][patchwork-package] for more details.
#'
#' @importFrom grid unit
#' @export
#'
#' @examples
#' library(ggplot2)
#'
#' ggplot(mtcars, aes(wt, mpg)) + geom_point() + add_correlaid_logo()
#'
#' ggplot(example_projects_labels, aes(category)) +
#'  geom_bar() +
#'  labs(title = "Title", subtitle = "Subtitle", caption = "Caption") +
#'  theme_correlaid() +
#'  add_correlaid_logo()
#'
#' # Change colour scale after adding logo:
#' # Plot becomes a `patchwork` object after adding logo.
#' # Use the `&` operator to modify ggplots in a patchwork.
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point(size = 3) +
#'   theme_correlaid(base_size = 20) +
#'   add_correlaid_logo() +
#'   scale_colour_correlaid_c()
add_correlaid_logo <- function() {
  structure(
    list(),
    class = "logo_patch",
    fn = "add_correlaid_logo_"
  )
}

#' @importFrom rlang `%||%`
add_correlaid_logo_ <- function(p) {
  base_size <- p$theme$text$size %||% 11

  p$labels$caption <- p$labels$caption %||% ""

  logo <- grImport2::readPicture(
    system.file("img", "correlaid-icon-cairo.svg", package = "correltools")
  )

  logo_width <- base_size * 2.1

  logo_grob <- grImport2::symbolsGrob(
    logo,
    x = unit(1, "npc") - unit(logo_width / 3, "pt"),
    y = unit(0, "npc") + unit(logo_width / 3, "pt"),
    size = unit(logo_width, "pt")
  )

  plot_margin <- unit(base_size * 1.4, "pt")

  p +
    patchwork::inset_element(
      logo_grob,
      left = unit(1, "npc") - plot_margin - unit(logo_width, "pt"),
      bottom = unit(0, "npc") + plot_margin,
      right = unit(1, "npc") - plot_margin,
      top = unit(0, "npc") + plot_margin + unit(logo_width, "pt"),
      align_to = "full", clip = FALSE, on_top = FALSE
    )
}

#' @importFrom ggplot2 ggplot_add
#' @export
ggplot_add.logo_patch <- function(object, p, objectname) {
  fn <- attr(object, "fn")
  do.call(fn, list(p))
}

#' @export
print.logo_patch <- function(x) {
  print(ggplot2::ggplot() + ggplot2::theme_void() + x)
  invisible(x)
}
