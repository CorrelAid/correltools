#' Theme inspired by https://correlaid.org/ website
#'
#' Theme inspired by the colors on
#' \href{correlaid.org}{https://correlaid.org/}.
#'
#' @param ax_size size of the axis values. Defaults to 10
#' @param axt_size axis titles size. Defaults to 14
#' @param pt_size plot title size. Defaults to 14
#' @param lg_size legend title size. Defaults to 16
#'
#' @export
#' @example
#'
#'ggplot(mpg, aes(hwy)) +
#'    geom_histogram() +
#'    theme_correl()
#'
#'
#'
theme_correl_simple <- function(ax_size = 10,
                         axt_size = 14,
                         pt_size = 14,
                         lg_size = 16
                         ) {


  theme(

    panel.background = element_rect(fill = "#D8EEC2",
                                    linetype = "blank"
    ),
    panel.grid.major = element_line(linetype = "dotted",
                                    colour = "#538793"),

    panel.grid.minor = element_line(linetype = "blank"),

    axis.text = element_text(face = "bold",
                             colour = "#637562",
                             size = ax_size,
                             vjust = 0.6),

    axis.title = element_text(size = axt_size, colour = "#637562",
                              family = "mono",
                              face = "bold"),

    axis.ticks = element_line(linetype = "blank"),

    plot.title = element_text(
      color = "#637562",
      size = pt_size),

    plot.title.position = "plot",

    plot.margin = unit(c(1, 1, 1, 1), "lines"),

    legend.position = "bottom",

    legend.direction = "horizontal",

    legend.box = "vertical",

    legend.key = element_rect(fill = "white"),

    legend.title = element_text(face = "bold",
                                colour = "#637562",
                                size = lg_size,
                                family = "mono")

  )

}
