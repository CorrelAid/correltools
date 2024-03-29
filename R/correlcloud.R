#' creates new connection to CorrelCloud
#' @param usr character. user to use to connect to CorrelCloud. defaults to Sys.getenv("CORRELCLOUD_USR")
#' @param pwd character. password to use to connect to CorrelCloud. defaults to Sys.getenv("CORRELCLOUD_PWD")
#' @return ocs4R::ocsManager object that can be used to interact with the CorrelCloud
#' @export
new_correlcloud_con <- function(usr = Sys.getenv("CORRELCLOUD_USR"),
                                pwd = Sys.getenv("CORRELCLOUD_PWD")) {

  ocs4R::ocsManager$new(
    url = "https://correlcloud.org", user = usr, pwd = pwd)
}

#' creates new user in CorrelCloud
#' @param con ocs4R::ocsManager. connection to CorrelCloud as created by new_correlcloud_con
#' @param first_name character. first name of user.
#' @param last_name character. last name of user
#' @param email character. email address to send invitation to.
#' @param groups character. character vector of groups to add user to. defaults to NA.
#' @param user_id character. user_id/login. defaults to NA, i.e. creating user name from first_name and last_name.
#' @return the created user as per getUser method of ocs4R::ocsManager
#' @export
new_correlcloud_user <- function(con, first_name, last_name, email, groups = NA, user_id = NA) {
  # username if not specified
  if (is.na(user_id)) {
    # make sure trimmed
    first_name <- stringr::str_trim(first_name)
    last_name <- stringr::str_trim(last_name)

    # FirstL
    user_id <- paste0(stringr::str_to_title(first_name),
                       stringr::str_to_upper(stringr::str_sub(last_name, 1, 1)))
  }

  message("inviting user {user_id}")
  con$addUser(user_id, email = email)
  con$editUserDisplayName(user_id, paste(first_name, last_name))
  message("invited user {user_id}")
  invisible(con$getUser(user_id))
}


#' creates new group in CorrelCloud
#' @param con ocs4R::ocsManager. connection to CorrelCloud as created by new_correlcloud_con
#' @param group_id character. name of the group ("id")
#' @export
new_correlcloud_group <- function(con, group_id) {
  con$addGroup(group_id)
}

#' list all groups in CorrelCloud
#' @param con ocs4R::ocsManager. connection to CorrelCloud as created by new_correlcloud_con
#' @return character. character vector with all group ids in the CorrelCloud.
#' @export
get_correlcloud_groups <- function(con) {
  con$getGroups()
}

#' list all users in CorrelCloud
#' @param con ocs4R::ocsManager. connection to CorrelCloud as created by new_correlcloud_con
#' @return character. character vector with all user ids in the CorrelCloud.
#' @export
get_correlcloud_users <- function(con) {
  con$getUsers()
}


#' adds user to group
#' @param con ocs4R::ocsManager. connection to CorrelCloud as created by new_correlcloud_con
#' @param user_id character. user id of the user
#' @param group_id character. id of the group the user should be added to.
#' @return boolean. True if successful.
#' @export
add_correlcloud_user_to_group <- function(con, user_id, group_id) {
  if (!user_id %in% get_correlcloud_users(con)) {
    stop(paste("User", user_id, "does not exist. Create it first with new_correlcloud_user."))
  }
  if (!group_id %in% get_correlcloud_groups(con)) {
    stop(paste("Group", group_id, "does not exist. Create it first with new_correlcloud_group."))
  }
  con$addToGroup(user_id, group_id)
}