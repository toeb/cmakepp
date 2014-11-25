
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
		ref_isvalid(${func} )
		ans(is_ref_ref)

		if(is_ref_ref)
			ref_get(${func} )
			ans(res)
			set(${result} "${res}" PARENT_SCOPE)
			return()
		else()
			set(${func} ${${func}})
		endif()
	endif()


	path("${func}")
	ans(fpath)
	is_function_file(is_file "${fpath}")


	if(is_file)
		load_function(file_content "${fpath}")
		get_function_string(file_content "${file_content}")
		set(${result} ${file_content} PARENT_SCOPE)
		return()
	endif()


	is_function_cmake(is_cmake_func "${func}")

	if(is_cmake_func)
		set(${result} "macro(${func})\n ${func}(\${ARGN})\nendmacro()" PARENT_SCOPE)
		return()
	endif()


	if(NOT (is_string OR is_file OR is_cmake_func)  )
		message(FATAL_ERROR "the following is not a function: '${func}' ")
	endif()

	

endfunction()