
function(map_print_format)
	foreach(statement ${ARGN})
		map_format(res "${statement}")
		message("${res}")
	endforeach()
endfunction()