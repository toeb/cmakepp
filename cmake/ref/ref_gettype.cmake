function(ref_gettype ref result)
	ref_isvalid(  ${ref} is_ref)
	if(NOT is_ref)
		return_value(NOTFOUND)
	endif()
	# ref:global:type:123asd123

	string(REGEX REPLACE "ref:[^:]+:([^:]+):.*" "\\1" type "${ref}")
	return_value(${type})
endfunction()