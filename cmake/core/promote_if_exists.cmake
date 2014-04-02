
macro(promote_if_exists var_name)
  if(DEFINED ${var_name})
    promote(${var_name})
  endif()
endmacro()