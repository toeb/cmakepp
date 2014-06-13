macro(add_custom_target)
  _add_custom_target(${ARGN})
  target_register(${ARGN})
endmacro()