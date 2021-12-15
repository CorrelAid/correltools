foo <- function() crul::ok('https://httpbin.org/get')

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
