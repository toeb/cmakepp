
function(debug_message)
	if(NOT show_debug)
		return()
	endif()
	message(STATUS "${imported_function_name}: '${ARGN}' (caller: ${imported_caller_function_name})")
endfunction()