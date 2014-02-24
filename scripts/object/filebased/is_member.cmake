# returns true if ref is member of an object
function(is_member result ref)
	
	if(NOT EXISTS ${ref})
		return_value(false)
	endif()
	if(IS_DIRECTORY ${ref})
		return_value(false)
	endif()

	get_filename_component(obj ${ref} DIRECTORY )
	is_object(isobj ${obj})
	return_value(${isobj})
endfunction()