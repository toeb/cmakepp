# binds the function to the object passed as this
# and calls it with all further arguments
# example:
# obj contains a object this (obj_create)
# a func (somemethod this arg1 arg2 arg3) exists
# obj_bindcall(${this} somemethod 1 2 3)
# is evaluated to somemethod(${this} 1 2 3)
# if you know the name of the function statically you do not need to use this function
macro(obj_bindcall object function_name)
  set(args ${ARGN}) 
  list_to_string(args args " ")  
  debug_message("binding ${function_name} to ${this} and calling with (${args})")
  obj_pushcontext(${object})
  debug_message("${function_name}(\${this} \${args})")
  eval("${function_name}(${ARGN})")
  obj_popcontext()

endmacro()