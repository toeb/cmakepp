

function(test_execute_glob)
  cd("${CMAKE_CURRENT_BINARY_DIR}")
  glob(${ARGN})
  ans(test_files)
  list(LENGTH test_files len)
  message("found ${len} tests in path for '${ARGN}'")
  set(i 0)
  foreach(test ${test_files})
    math(EXPR i "${i} + 1")
    message(STATUS "test ${i} of ${len}")
    message_indent_push()
    test_execute("${test}")
    message_indent_pop()
    message(STATUS "done")
  endforeach()

endfunction()