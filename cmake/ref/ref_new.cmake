function(ref_new)
	ref_set(":0" 0)
	
	function(ref_new)
		ref_get(":0" )
		ans(index)
		math(EXPR index "${index} + 1")
		ref_set(":0" "${index}")
		if(ARGN)
		#	set(type "${ARGV0}")
			ref_set(":${index}.__type__" "${ARGV0}")
		endif()
		return(":${index}")
	endfunction()

	ref_new(${ARGN})
	return_ans()
endfunction()

## optimized version
function(ref_new)
	set_property(GLOBAL PROPERTY ":0" 0 )
	function(ref_new)
		get_property(index GLOBAL PROPERTY ":0")
		math(EXPR index "${index} + 1")
		set_property(GLOBAL PROPERTY ":0" ${index} )
		if(ARGN)
			set_property(GLOBAL PROPERTY ":${index}.__type__" "${ARGV0}")
		endif()
		set(__ans ":${index}" PARENT_SCOPE)
	endfunction()

	ref_new(${ARGN})
	return_ans()
endfunction()