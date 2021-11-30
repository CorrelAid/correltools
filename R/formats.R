#' html_document yeti theme adapted to CorrelAid CI
#' @param toc logical. whether or not to include a table of contents. defaults to TRUE
#' @param toc_float logical. whether or not the toc should float. defaults to TRUE
#' @param ... other arguments passed down to rmarkdown::html_document
#' @export
html_yeti <- function(toc = TRUE, toc_float = TRUE, ...) {
  # locations of resource files in the package
  pkg_resource = function(...) {
    system.file(..., package = "correltools")
  }

  css_correlaid <-  pkg_resource("ci/correlaid.css")
  css_yeti <-  pkg_resource("ci/yeti.css")
  html_header <-  pkg_resource("ci/header.html")

  # call the base html_document function
  rmarkdown::html_document(
    toc = toc, toc_float = toc_float,
    theme = "yeti", css = c(css_correlaid, css_yeti),
    includes = list(header = html_header),
    ...
  )
}
