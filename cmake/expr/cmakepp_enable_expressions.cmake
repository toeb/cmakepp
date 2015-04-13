## `()-><any>`
##
## this macro enables all expressions in the current scope
macro(cmakepp_enable_expressions line)
  cmakepp_compile_scope_expressions("${line}")
  ans(__cmakepp_enable_expressions_code)
  eval_ref(__cmakepp_enable_expressions_code)
  unset(__cmakepp_enable_expressions_code)
  _return()
endmacro()


