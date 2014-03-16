function(compress target dir)
	cmake_parse_arguments("" "RELATIVE;GLOB" "" "" ${ARGN})
	set(globs ${ARGN})
	if(_RELATIVE)
		set(globs)
		foreach(glob ${_UNPARSED_ARGUMENTS})
			set(globs ${globs} "${dir}/${glob}")
		endforeach()

	endif()
	if(_GLOB)
		file(GLOB globs RELATIVE "${dir}" ${globs})
	endif()

	
	file(WRITE "${target}" "")
	set(cmd  ${CMAKE_COMMAND} -E tar cvzf "${target}" ${globs})
	execute_process(
		COMMAND ${cmd}
		WORKING_DIRECTORY "${dir}"		
		OUTPUT_QUIET
	)

endfunction()