function(ref_new)
	ref_set(__global_ref_count 0)
	
	function(ref_new)
		ref_get(__global_ref_count )
		ans(index)
		math(EXPR index "${index} + 1")
		ref_set(__global_ref_count "${index}")
		if(ARGN)
			set(type "${ARGV0}")
			ref_set(":${index}.__type__" "${type}")
		endif()
		return(":${index}")
	endfunction()

	ref_new(${ARGN})
	return_ans()
endfunction()