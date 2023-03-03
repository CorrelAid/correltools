#' low level function to get data from directus
#' @param endpoint character. REST endpoint to get. Refer to [the API reference](https://docs.directus.io/reference/introduction.html).
#' @param parse boolean. whether or not to parse the result. defaults to true.
#' @param token character. API token for Directus, defaults to environment variable DIRECTUS_TOKEN.
#' @param limit integer. how many objects to return. defaults to -1 meaning all objects.
#' @return httr return object if `parse = FALSE`. parsed content of httr result if `parse = TRUE`.
#' @export
directus_get_ <- function(endpoint, parse = TRUE, token = Sys.getenv("DIRECTUS_TOKEN"), limit = -1) {
  res <- httr::GET(paste0("https://correlaid.directus.app/", endpoint),
                   query = list(limit = limit),
                   httr::add_headers(
                     authorization = paste0("Bearer ", token)))
  httr::stop_for_status(res)

  if (!parse) return(res)
  httr::content(res, "text") %>% jsonlite::fromJSON()
}

#' get data from directus
#' @param endpoint character. REST endpoint to get. Refer to [the API reference](https://docs.directus.io/reference/introduction.html).
#' @param token character. API token for Directus, defaults to environment variable DIRECTUS_TOKEN.
#' @param limit integer. how many objects to return. defaults to -1 meaning all objects.
#' @return list. parsed content of httr return object
#' @export
directus_get <- function(endpoint, token = Sys.getenv("DIRECTUS_TOKEN"), limit = -1) {
  directus_get_(endpoint, token = token)
}


#' post/create data in directus
#' @param endpoint character. REST endpoint to post to. Refer to [the API reference](https://docs.directus.io/reference/introduction.html).
#' @param body list. body to post to Directus. Can be a list of lists (for multiple elements at once) or a single list (for only one element).
#' @param token character. API token for Directus, defaults to environment variable DIRECTUS_TOKEN.
#' @return httr return object
#' @export
directus_post <- function(endpoint, body, token = Sys.getenv("DIRECTUS_TOKEN")) {
  body_json <- jsonlite::toJSON(body, auto_unbox = TRUE)
  res <- httr::POST(paste0("https://correlaid.directus.app/", endpoint),
                    body = body_json,
                    httr::add_headers(
                      authorization = paste0("Bearer ", token),
                      accept = "application/json"),
                    httr::content_type("application/json; charset=UTF-8"))
  res
}

#' patch/edit data in directus
#' @param endpoint character. REST endpoint to patch. Refer to [the API reference](https://docs.directus.io/reference/introduction.html).
#' @param id integer. id of the element to be patched.
#' @param body list. updates to patch. do not include the id of the element.
#' @param token character. API token for Directus, defaults to environment variable DIRECTUS_TOKEN.
#' @return httr return object
#' @export
directus_patch <- function(endpoint, id, body, token = Sys.getenv("DIRECTUS_TOKEN")) {
  body_json <- jsonlite::toJSON(body, auto_unbox = TRUE)
  res <- httr::PATCH(paste0("https://correlaid.directus.app/", endpoint, "/", id),
                     body = body_json,
                     httr::add_headers(
                       authorization = paste0("Bearer ", token),
                       accept = "application/json"),
                     httr::content_type("application/json; charset=UTF-8"))
  res
}
