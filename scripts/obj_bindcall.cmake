# binds the function to the object passed as this
# and calls it with all further arguments
# example:
# obj contains a object this (obj_create)
# a func (somemethod this arg1 arg2 arg3) exists
# obj_bindcall(${this} somemethod 1 2 3)
# is evaluated to somemethod(${this} 1 2 3)
# if you know the name of the function statically you do not need to use this function
macro(obj_bindcall object func)
	# here is the problem!  sometimes function_name contains a function
  set(args ${ARGN}) 
  list_to_string(args args " ")  
  debug_message("binding ${func} to ${this} and calling with (${args})")
  obj_pushcontext(${object})
  debug_message("${func}(\${this} \${args})")
  import_function("${func}" as bound_function REDEFINE)
  bound_function(${ARGN})
  #eval("${function_name}(${ARGN})")
  obj_popcontext()

endmacro()