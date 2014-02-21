function(obj_call this)
	is_object(is_obj ${this})
	if(is_obj)
		obj_callobject(${this} ${ARGN})
		return()
	endif()

	is_member(is_mem ${this})
	is_function(is_func ${this})

	if(is_mem AND is_func)
		obj_callref(${this} ${ARGN})
		return()
	else(is_func)
		message(FATAL_ERROR "implement call func")
	endif()

	message(FATAL_ERROR "could not call ${this}")
endfunction()