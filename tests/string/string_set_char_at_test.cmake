function(test)
  set(str "hello")

  set(res "")
  # Second char is set from "e" to "a"
  string_set_char_at(1 ${str} a)
  ans(res)
  assert("${res}" STREQUAL "hallo")

  set(res "")
  # Test for negative indexing
  # index of -2 is last char of string
  string_set_char_at(-2 ${str} a)
  ans(res)
  assert("${res}" STREQUAL "hella")

  set(res "")
  # Out of bounds positive index
  string_set_char_at(6 ${str} a)
  ans(res)
  assert("${res}_" STREQUAL "_")

  set(res "")
  # Out of bounds negative index (1/2)
  string_set_char_at(-7 ${str} a)
  ans(res)
  assert("${res}_" STREQUAL "_")

  set(res "")
  # Out of bounds negative index (2/2)
  string_set_char_at(-1 ${str} a)
  ans(res)
  assert("${res}_" STREQUAL "_")

  set(str "hello three words")

  set(res "")
  # Test for negative indexing
  # Multi word string
  string_set_char_at(-2 ${str} e)
  ans(res)
  assert("${res}" STREQUAL "hello three worde")

  set(res "")
  # Test to set whitespace char to "s"
  string_set_char_at(5 ${str} s)
  ans(res)
  assert("${res}" STREQUAL "hellosthree words")

  set(res "")
  # Set first char of input string to empty char (delete)
  string_set_char_at(0 ${str} "")
  ans(res)
  assert("${res}" STREQUAL "ello three words")

  set(res "")
  # Set last char of input string to empty char (delete)
  string_set_char_at(-2 ${str} "")
  ans(res)
  assert("${res}" STREQUAL "hello three word")

  set(res "")
  # Set an inner char of input string to empty char (delete)
  string_set_char_at(5 ${str} "")
  ans(res)
  assert("${res}" STREQUAL "hellothree words")
endfunction()
