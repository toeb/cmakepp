function(ref_append ref)
	set_property( GLOBAL APPEND PROPERTY "${ref}" "${ARGN}")
endfunction()