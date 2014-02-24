# returns the specified functor or if functor is only a function
# creates a functor object
function(obj_makefunctor result functor)
	# return functor directly if it actually is a functor
	obj_isfunctor(is_functor "${functor}")
	if(is_functor)
		return_value("${functor}")
	endif()
	#this is superfluos because obj_newfunctor also performs this check
	is_function(is_func ${functor})
	if(NOT is_func)
		message(FATAL_ERROR "obj_makefunctor expects a function or functor as input argument")
	endif()
	# create the functor
	obj_newfunctor(res "${functor}")

	return_value(${res})
endfunction()