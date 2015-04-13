## `(${CMAKE_CURRENT_LIST_LINE})-><any>`
##
## this macro enables all expressions in the current scope
## you need to pass `${CMAKE_CURRENT_LIST_LINE}` for this to work
macro(cmakepp_enable_expressions line)
  cmakepp_compile_scope_expressions("${line}")
  ans(__cmakepp_enable_expressions_code)
  eval_ref(__cmakepp_enable_expressions_code)
  unset(__cmakepp_enable_expressions_code)
  _return()
endmacro()


