function(test)
  # Empty string
  set(input "")
  string_split("${input}" "@")
  ans(res)
  assert("${res}_" STREQUAL "_")

  # Nothing is split
  set(input "a@b")
  string_split("${input}" "c")
  ans(res)
  assert("${res}" STREQUAL "a@b")

  # Middle split
  set(input "a@b")
  string_split("${input}" "@")
  ans(res)
  set(expected a b)
  #assert_list_equal(res expected)
  assert(EQUALS "${res}" "${expected}")
  
  # Two split chars
  set(input "a@b@c")
  string_split("${input}" "@")
  ans(res)
  set(expected a b c)
  assert(EQUALS "${res}" "${expected}")

  # Nothing to split
  set(input "word")
  string_split("${input}" "@")
  ans(res)
  assert(NOT ${res})

  # Split at beginning
  set(input "@end")
  string_split("${input}" "@")
  ans(res)
  set(expected "end")
  assert(EQUALS "${res}" "${expected}")

  # Split at end
  set(input "beginning@")
  string_split("${input}" "@")
  ans(res)
  set(expected "beginning")
  assert(EQUALS "${res}" "${expected}")
endfunction()