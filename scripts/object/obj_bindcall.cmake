# binds the function to the object passed as this
# loads all propertyies of object into scope (obj_loadcontext)
macro(obj_bindcall object func)
	# here is the problem!  sometimes function_name contains a function
  set(args ${ARGN}) 
  list_to_string(args args " ")  
  #debug_message("binding ${func} to ${this} and calling with (${args})")
  obj_pushcontext(${object})
  #debug_message("${func}(\${this} \${args})")
  import_function("${func}" as bound_function REDEFINE)
  bound_function(${ARGN})
  obj_popcontext()

endmacro()