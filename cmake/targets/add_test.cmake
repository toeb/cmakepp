
macro(add_test)
  _add_test(${ARGN})
  target_register(${ARGN})

endmacro()