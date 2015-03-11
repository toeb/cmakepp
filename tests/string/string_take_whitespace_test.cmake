function(test)


  timer_start(t1)

  foreach(i RANGE 0 1000)
    set(str "   asd")
    string_take_whitespace(str)

  endforeach()

  timer_print_elapsed(t1)


  set(CMAKE_MATCH_1 "fkfkfkf")
  set(CMAKE_MATCH_2 "fkfkfkf")
  set(str "  asd")
  string_take_whitespace(str)
  ans(res)
  assert("${res}" STREQUAL "  ")
  assert("${str}" STREQUAL "asd")

  set(CMAKE_MATCH_1 "fkfkfkf")
  set(CMAKE_MATCH_2 "fkfkfkf")
  set(str "  ")
  string_take_whitespace(str)
  ans(res)
  assert("${res}" STREQUAL "  ")
  assert("${str}_" STREQUAL "_")

  set(CMAKE_MATCH_1 "fkfkfkf")
  set(CMAKE_MATCH_2 "fkfkfkf")
  set(str "asdasda")
  string_take_whitespace(str)
  ans(res)
  assert("${res}_" STREQUAL "_")
  assert("${str}" STREQUAL "asdasda")


  set(CMAKE_MATCH_1 "fkfkfkf")
  set(CMAKE_MATCH_2 "fkfkfkf")
  set(str)
  string_take_whitespace(str)
  ans(res)
  assert("${res}_" STREQUAL "_")
  assert("${str}_" STREQUAL "_")
endfunction()