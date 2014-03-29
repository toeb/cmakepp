
macro(add_executable)
  _add_executable(${ARGN})
  target_register(${ARGN})
endmacro()