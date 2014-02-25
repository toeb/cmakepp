# creates a functor from a cmake function
# a functor is a callable object
function(obj_newfunctor result function_ref)
	is_function(is_func ${function_ref})
	if(NOT is_func)
		message(FATAL_ERROR "new_functor expected a functiony argument")
	endif()
	obj_create(this)
	obj_create(proto)
	obj_setprototype(${this} ${proto})
	obj_set(${this} __call__ "${function_ref}")
	return_value(${this})
endfunction()