function(test)


  semver_normalize("1")
  semver_format(${__ans})
  ans(res)
  assert("${res}" STREQUAL "1.0.0")

  semver_normalize("")
  semver_format(${__ans})
  ans(res)
  assert("${res}" STREQUAL "0.0.0")

  semver_normalize("1.0")
  semver_format(${__ans})
  ans(res)
  assert("${res}" STREQUAL "1.0.0")

endfunction()