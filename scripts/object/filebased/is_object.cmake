# returns true if ref is an object
function(is_object  result ref)
	if(IS_DIRECTORY "${ref}")
		return_value(true)
	else()
		return_value(false)
	endif()
	
endfunction()

