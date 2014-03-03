# includes a file once in current scope.
function (include_once file_or_module)
	string_normalize_string(guard "${file_or_module}")
	#string(MAKE_C_IDENTIFIER ${file_or_module} guard)
	get_property(was_included GLOBAL PROPERTY ${guard})
	if(was_included)
		debug_message("script already included ${file_or_module} ")
		return()
	endif()

	set_property(GLOBAL PROPERTY ${guard} true)
	include("${file_or_module}" RESULT_VARIABLE actual_file)
	debug_message("included ${actual_file} ")

endfunction()