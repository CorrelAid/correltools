test_that("creating a user works", {
  con <- new_correlcloud_con()
  vcr::use_cassette("correlcloud-create-user", {
    user <- new_correlcloud_user(con, "First", "Last", "first@example.com")
  })
  expect_equal(user$email, "first@example.com")
  expect_equal(user$displayname, "First Last")
  expect_equal(user$id, "FirstL")
})


test_that("overwriting the username works", {
  con <- new_correlcloud_con()
  vcr::use_cassette("correlcloud-create-user-overwrite-username", {
    user <- new_correlcloud_user(con, "First", "Last", "first@example.com", username = "FooB")
  })
  expect_equal(user$email, "first@example.com")
  expect_equal(user$displayname, "First Last")
  expect_equal(user$id, "FooB")
})


test_that("creating a new group works", {
  con <- new_correlcloud_con()
  vcr::use_cassette("correlcloud-create-group", {
    res <- new_correlcloud_group(con, "testgroup")
    expect_true(res)
  })
})


test_that("trying to add a non-existing user to a group results in error", {
  con <- new_correlcloud_con()
  # turn off vcr and turn on webmockr
  vcr::turned_off({
    webmockr::enable("httr")

    # stub requests (we don't want the real user names and group names in vcr cassettes)
    stub_users <- webmockr::stub_request(uri = "https://correlcloud.org/ocs/v1.php/cloud/users?format=json")
      webmockr::to_return(stub_users, body = '{"ocs":{"meta":{"status":"ok","statuscode":100,"message":"OK","totalitems":"","itemsperpage":""},"data":{"users":["FooB", "User1", "User2", "Bar"]}}}')
    stub_groups <- webmockr::stub_request(uri = "https://correlcloud.org/ocs/v1.php/cloud/groups?format=json")
      webmockr::to_return(stub_groups, body = '{"ocs":{"meta":{"status":"ok","statuscode":100,"message":"OK","totalitems":"","itemsperpage":""},"data":{"groups":["Group1", "Group2", "admin"]}}}')

    expect_error(add_correlcloud_user_to_group(con, "jwelrjwlerjwl", "test"), regexp = "^User .+? does not exist.")
    expect_error(add_correlcloud_user_to_group(con, "User2", "doesnotexist"), regexp = "^Group .+? does not exist.")

    webmockr::disable()
  })
})
