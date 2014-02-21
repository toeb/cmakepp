function(obj_setmethod this identifier)
	function(function_load result identifier)
		if(EXISTS ${identifier})
			return_value("${identifier}")
		endif()

		if(EXISTS "${identifier}.cmake")
			return_value("${identifier}.cmake")
		endif()

		if(COMMAND ${identifier})
			temp_file(fname)
			file(WRITE ${fname} "macro(call_${identifier})\n  ${identifier}(\${ARGN}) \n endmacro()")
			return_value(temp_file)
		endif()


		return_value(NOTFOUND)

	endfunction()

	function_load(function_file ${identifier})
	if(NOT function_file)
		message(FATAL_ERROR "specified function '${identifier}' does not exist")
	endif()
	obj_setbyfile(${this} "${function_file}")

endfunction()