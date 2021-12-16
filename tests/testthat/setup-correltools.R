library("vcr") # *Required* as vcr is set up on loading
library("webmockr")
invisible(vcr::vcr_configure(
  dir = vcr::vcr_test_path("fixtures"),
  filter_request_headers = list(Authorization = "fake token", `set-cookie` = "filtered cookies"),
  filter_response_headers = list(`set-cookie` = "filtered cookies")
))
vcr::check_cassette_names()
