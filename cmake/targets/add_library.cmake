
macro(add_library)
  _add_library(${ARGN})
  target_register(${ARGN})
  
endmacro()