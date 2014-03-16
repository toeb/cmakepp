function(uncompress target file)	
	file(MAKE_DIRECTORY "${target}")
	set(cmd  ${CMAKE_COMMAND} -E tar xzf "${file}")
	execute_process(
		COMMAND ${cmd}
		WORKING_DIRECTORY "${target}"		
		OUTPUT_QUIET
	)
endfunction()