function(obj_hasownproperty ref result key)
	if(EXISTS "${ref}/${key}")
		return_value(TRUE)
	endif()
	return_value(FALSE)
endfunction()


