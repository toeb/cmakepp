function(obj_getrefvalue this result)
	#ref_gettype(type ${this})

	map_navigate(res ${this})
	set(${result} "${res}" PARENT_SCOPE)
	
	#if(EXISTS "${this}" AND NOT IS_DIRECTORY ${this} )
#		file(READ "${this}" res)
#		set(${result} "${res}" PARENT_SCOPE)
#		return()
#	endif()
#	return_value(NOTFOUND)
endfunction()