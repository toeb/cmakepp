
function(file_istarfile result file)
	set(cmd  ${CMAKE_COMMAND} -E tar ztvf "${file}")
	execute_process(
		COMMAND ${cmd}
		WORKING_DIRECTORY "${target}"		
		OUTPUT_QUIET
		ERROR_QUIET
		RESULT_VARIABLE res
	)		
	if(${res} STREQUAL "0")
		return_value(true)
	else()
		return_value(false)
	endif()

endfunction()