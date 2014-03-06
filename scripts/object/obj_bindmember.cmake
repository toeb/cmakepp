# gets a member function and returns a boundfunction (the function is bound to the object)
# which can be called via function_call
function(obj_bindmember  bound_function object member_to_bind)
	obj_get(${object} func ${member_to_bind})
	obj_bind(result ${object} "${func}")
	set(${bound_function} "${result}" PARENT_SCOPE)
endfunction()