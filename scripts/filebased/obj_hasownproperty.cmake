function(obj_hasownproperty this result key)
	if(EXISTS "${this}/${key}")
		return_value(TRUE)
	endif()
	return_value(FALSE)
endfunction()


