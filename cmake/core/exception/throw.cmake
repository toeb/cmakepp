## `(<exception> | <any>)->`
##
## may be used in functions.  causes the function to 
## return with an exception which can be caught
macro(throw)
  exception("${ARGN}")
  return_ans()
endmacro()