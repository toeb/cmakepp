
# returns the implementation of the function (a string containing the source code)
# this only works for functions files and function strings. CMake does not offer
# a possibility to get the implementation of a defined function or macro.
function(get_function_string result func)

	is_function_string(is_string "${func}")
	if(is_string)
		set(${result} ${func} PARENT_SCOPE)
		return()
	endif()

	
	is_function_ref(is_ref "${func}")
	if(is_ref)
		set(${func} ${${func}})
	endif()


	is_function_file(is_file "${func}")


	if(is_file)
		load_function(file_content "${func}")
		set(${result} ${file_content} PARENT_SCOPE)
		return()
	endif()


	is_function_cmake(is_cmake_func "${func}")

	if(is_cmake_func)
		set(${result} "macro(${func})\n debug_message(\"wrapper for '${func}' called \")\nif(NOT COMMAND \"${func}\") \n message(FATAL_ERROR \"wrapper for '${func}' failed because '${func}' is not defined \") \n endif() \n ${func}(\${ARGN}) \n endmacro ()" PARENT_SCOPE)
	endif()

	if(NOT (is_string OR is_file OR is_cmake_func)  )
		message(FATAL_ERROR "the following is not a function: '${func}' ")
	endif()
endfunction()