#' CorrelAid palette
#'
#' Create a colour palette based on the [CorrelAid design guide](https://docs.correlaid.org/wiki/design-guide)
#'
#' @param direction Sets the order of colours in the scale:
#'
#'   - 1: default order
#'   - -1: reversed order
#' @param option A character string indicating the colour palette to use.
#'   Three options are available: "qualitative", "gradient" and "gradient_x".
#'   See [`correlaid_colours`] for more information.
#'
#' @seealso [`correlaid_colours`], [scale_colour_correlaid_d()] etc.
#'
#' @return A function that takes an integer argument (the required number of colours)
#'   and returns a character vector of colours
#' @export
#'
#' @examples
#' scales::show_col(correlaid_pal()(6))
#' scales::show_col(correlaid_pal(option = "gradient")(9))
#' scales::show_col(correlaid_pal(direction = -1, option = "gradient_x")(9))
correlaid_pal <- function(direction = 1, option = "qualitative") {
  stopifnot(length(option) == 1 && option %in% names(correltools::correlaid_colours))

  cols <- correltools::correlaid_colours[[option]]

  function(n) {
    if (option == "qualitative") {
      if (n > length(correltools::correlaid_colours[[option]])) {
        warning(
          paste(
            "CorrelAid qualitative colour palette only has",
            length(correltools::correlaid_colours[[option]]),
            'colours.\nConsider setting option = "gradient" or "gradient_x" instead.'
          ),
          call. = FALSE
        )
      }
      cols <- unname(cols[1:n])
    } else {
      cols <- grDevices::colorRampPalette(cols, space = "Lab", interpolate = "spline")(n)
    }

    if (direction < 0) rev(cols) else cols
  }
}

# Discrete scales ---------------------------------------------------------

#' CorrelAid colour scales for ggplot2
#'
#' Discrete, continuous and binned ggplot2 colour and fill scales
#'   based on the [CorrelAid design guide](https://docs.correlaid.org/wiki/design-guide).
#'   For a list of available palettes and colours see [`correlaid_colours`].
#'
#' - The suffix `_d` indicates that the scale is discrete.
#' - `_c`: continuous scale.
#' - `_b`: binned scale.
#'
#' @inheritParams correlaid_pal
#' @param guide A function used to create a guide or its name.
#'   See [ggplot2::guides()] for more information.
#' @param ... Other arguments passed on to [ggplot2::discrete_scale()],
#'   [ggplot2::continuous_scale()], or [ggplot2::binned_scale()]
#'   to control name, limits, breaks, labels etc.
#'
#' @seealso [`correlaid_colours`], [correlaid_pal()]
#'
#' @rdname scale_correlaid
#'
#' @export
#'
#' @examples
#'
#' library(ggplot2)
#'
#' ggplot(example_projects_labels, aes(category, fill = category)) +
#'   geom_bar(show.legend = FALSE) +
#'   scale_fill_correlaid_d(option = "gradient") +
#'
#' ggplot(mtcars, aes(wt, mpg, colour = mpg)) +
#'   geom_point(size = 5) +
#'   scale_colour_correlaid_c()
#'
#' ggplot(mtcars, aes(wt, mpg, fill = mpg)) +
#'   geom_point(shape = 21, colour = "white", size = 5) +
#'   scale_fill_correlaid_b()
scale_colour_correlaid_d <- function(direction = 1,
                                     option = "qualitative",
                                     ...) {
  ggplot2::discrete_scale(
    "colour", "correlaid",
    correlaid_pal(direction, option),
    ...
  )
}

#' @rdname scale_correlaid
#' @export
scale_color_correlaid_d <- scale_colour_correlaid_d

#' @rdname scale_correlaid
#' @export
scale_fill_correlaid_d <- function(direction = 1,
                                   option = "qualitative",
                                   ...) {
  ggplot2::discrete_scale(
    "fill", "correlaid",
    correlaid_pal(direction, option),
    ...
  )
}

# Continuous scales -------------------------------------------------------

#' @rdname scale_correlaid
#' @export
scale_colour_correlaid_c <- function(direction = 1,
                                     option = "gradient",
                                     guide = "colourbar",
                                     ...) {
  if (option == "qualitative") {
    stop("Qualitative palette cannot be used with a continuous scale.")
  }

  ggplot2::continuous_scale(
    "colour", "correlaid",
    scales::gradient_n_pal(correlaid_pal(direction, option)(8)),
    guide = guide, ...
  )
}

#' @rdname scale_correlaid
#' @export
scale_color_correlaid_c <- scale_colour_correlaid_c

#' @rdname scale_correlaid
#' @export
scale_fill_correlaid_c <- function(direction = 1,
                                   option = "gradient",
                                   guide = "colourbar",
                                   ...) {
  if (option == "qualitative") {
    stop("Qualitative palette cannot be used with a continuous scale.")
  }

  ggplot2::continuous_scale(
    "fill", "correlaid",
    scales::gradient_n_pal(correlaid_pal(direction, option)(8)),
    guide = guide, ...
  )
}

# Binned scales -----------------------------------------------------------

#' @rdname scale_correlaid
#' @export
scale_colour_correlaid_b <- function(direction = 1,
                                     option = "gradient",
                                     guide = "coloursteps",
                                     ...) {
  if (option == "qualitative") {
    stop("Qualitative palette cannot be used with a continuous scale.")
  }

  ggplot2::binned_scale(
    "colour", "correlaid",
    scales::gradient_n_pal(correlaid_pal(direction, option)(8)),
    guide = guide, ...
  )
}

#' @rdname scale_correlaid
#' @export
scale_color_correlaid_b <- scale_colour_correlaid_b

#' @rdname scale_correlaid
#' @export
scale_fill_correlaid_b <- function(direction = 1,
                                   option = "gradient",
                                   guide = "coloursteps",
                                   ...) {
  if (option == "qualitative") {
    stop("Qualitative palette cannot be used with a continuous scale.")
  }

  ggplot2::binned_scale(
    "fill", "correlaid",
    scales::gradient_n_pal(correlaid_pal(direction, option)(8)),
    guide = guide, ...
  )
}
