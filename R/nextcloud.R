#' creates new connection to CorrelCloud
#' @param usr character. user to use to connect to CorrelCloud. defaults to Sys.getenv("NEXTCLOUD_USR")
#' @param pwd character. password to use to connect to CorrelCloud. defaults to Sys.getenv("NEXTCLOUD_PWD")
#' @return ocs4R::ocsManager object that can be used to interact with the CorrelCloud
#' @export
new_correlcloud_con <- function(usr = Sys.getenv("NEXTCLOUD_USR"),
                                pwd = Sys.getenv("NEXTCLOUD_PWD")) {

  ocs4R::ocsManager$new(
    url = "https://correlcloud.org", user = usr, pwd = pwd)
}

#' creates new user in CorrelCloud
#' @param con ocs4R::ocsManager. connection to CorrelCloud as created by new_correlcloud_con
#' @param first_name character. first name of user.
#' @param last_name character. last name of user
#' @param email character. email address to send invitation to.
#' @param groups character. character vector of groups to add user to. defaults to c("User").
#' @param username character. username/login. defaults to NA, i.e. creating user name from first_name and last_name.
#' @return the created user as per getUser method of ocs4R::ocsManager
#' @export
new_correlcloud_user <- function(con, first_name, last_name, email, groups = c("User"), username = NA) {
  # username if not specified
  if (is.na(username)) {
    # make sure trimmed
    first_name <- stringr::str_trim(first_name)
    last_name <- stringr::str_trim(last_name)

    # FirstL
    username <- paste0(stringr::str_to_title(first_name),
                       stringr::str_to_upper(stringr::str_sub(last_name, 1, 1)))
  }

  message("inviting user {username}")
  con$addUser(username, email = email)
  con$editUserDisplayName(username, paste(first_name, last_name))
  message("invited user {username}")
  invisible(con$getUser(username))
}
