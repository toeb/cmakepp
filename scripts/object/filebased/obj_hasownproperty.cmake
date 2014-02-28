function(obj_hasownproperty this result key)
	if(EXISTS "${this}/${key}" AND NOT IS_DIRECTORY "${this}/${key}" )
		return_value(TRUE)
	endif()
	return_value(FALSE)
endfunction()


