

function(ref_get result ref)
	#local ref
	

	get_property(res GLOBAL PROPERTY "${ref}")
	set("${result}" "${res}" PARENT_SCOPE)
endfunction()