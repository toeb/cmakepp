function(test)
  string_ends_with("asdf" "df")
  ans(res)
  assert(res)

  string_ends_with("asdf" "mu")
  ans(res)
  assert(NOT res)
endfunction()