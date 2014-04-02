macro(promote var_name)
  set(${var_name} ${${var_name}} PARENT_SCOPE)
endmacro()  