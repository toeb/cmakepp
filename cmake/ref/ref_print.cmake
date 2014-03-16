function(ref_print ref)
	json_serialize(res "${ref}" INDENTED)

	message("${res}")
	foreach(arg ${ARGN})
		ref_print("${arg}")
	endforeach()
endfunction()