# binds a the functor specified by ${object}
# expects ${object} to be a functor
# returns a unique function id which can be called via call_function()
function(obj_bindfunctor result object)
	obj_isfunctor(is_functor ${object})
	if(NOT is_functor)
		message(FATAL_ERROR "obj_bindfunctor object is not a functor: '${object}'")
	endif()
	obj_bindmember(res ${object} __call__)
	return_value(${res})
endfunction()