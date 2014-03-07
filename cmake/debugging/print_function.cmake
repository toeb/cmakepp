
function(print_function func)
	get_function_lines(lines "${func}")
	set(i "0")
	foreach(line ${lines})		
		message(STATUS "LINE ${i}: ${line}")
		math(EXPR i "${i} + 1")
	endforeach()
endfunction()