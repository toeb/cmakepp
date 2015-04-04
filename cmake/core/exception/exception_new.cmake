##
##
## an exception is map `<exception> ::= { message: <string> }` of $type `exception` 
## if checked in an if statement it evaluates to false because it ends with -NOTFOUND
## 
function(exception_new message)
  address_new()
  ans(error)
  set(error "${error}-NOTFOUND")
  map_set(${error} message "${message}")
  map_set_special(${error} $type exception)
  return_ref(error)
endfunction()