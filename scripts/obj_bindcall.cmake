# binds the function to the object passed as ref
# and calls it with all further arguments
# example:
# obj contains a object ref (obj_create)
# a func (somemethod this arg1 arg2 arg3) exists
# obj_bindcall(${ref} somemethod 1 2 3)
# is evaluated to somemethod(${ref} 1 2 3)
# if you know the name of the function statically you do not need to use this function
macro(obj_bindcall ref function_name)
  set(args ${ARGN}) 
  list_to_string(args args " ")  
  eval("${function_name}(${ref} ${args})")
endmacro()