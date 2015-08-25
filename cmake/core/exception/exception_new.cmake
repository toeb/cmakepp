##
##
## an exception is map `<exception> ::= { message: <string> }` of $type `exception` 
## if checked in an if statement it evaluates to false because it ends with -NOTFOUND
## 
function(exception_new)
  address_new()
  ans(exception)
  set(exception "${exception}-NOTFOUND")
  set(args ${ARGN})
  list_pop_front(args)
  ans(code)
  map_set(${exception} code "${code}")
  map_set(${exception} message ${args})
  map_set_special(${exception} $type exception)
  return_ref(exception)
endfunction()