function(ref_print ref)
	json_serialize(res ${ref} INDENTED)
	message("${res}")

endfunction()