function(compress target dir)

	set(globs)
	foreach(glob ${ARGN})
		set(globs ${globs} "${dir}/${glob}")
	endforeach()

	file(GLOB globs RELATIVE "${dir}" ${globs})

	
	file(WRITE "${target}" "")
	set(cmd  ${CMAKE_COMMAND} -E tar cvzf "${target}" ${globs})
	execute_process(
		COMMAND ${cmd}
		WORKING_DIRECTORY "${dir}"		
		OUTPUT_QUIET
	)

endfunction()