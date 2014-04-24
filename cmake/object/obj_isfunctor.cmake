# returns true if passed ref is a functor
# that means ref is an object, has the member __call__
# and __call__ is a function
function(obj_isfunctor result ref)
	is_object(res ${ref})
	if(NOT res)
		return_value(false)
	endif()
	obj_has(${ref} res "__call__")
	if(NOT res)
		return_value(false)
	endif()
	obj_get(${ref}  "__call__")
	ans(func)
	is_function(res "${func}")
	if(NOT res)
		
		return_value(false)
	endif()
	return_value(true)
endfunction()