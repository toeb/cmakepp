function(obj_hasownproperty this result key)
	map_has(${this} res ${key})
	return_value(${res})
	#return()
	#if(EXISTS "${this}/${key}" AND NOT IS_DIRECTORY "${this}/${key}" )
	#	return_value(TRUE)
	#endif()
	#return_value(FALSE)
endfunction()


