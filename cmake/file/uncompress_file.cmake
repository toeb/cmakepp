#uncompresses specific files from archive specified by varargs
function(uncompress_file target archive)
#tar -zxvf config.tar.gz etc/default/sysstat
	if(NOT IS_DIRECTORY "${target}")
		file(MAKE_DIRECTORY "${target}")
	endif()
	set(cmd ${CMAKE_COMMAND} -E tar -zxvf "${archive}" ${ARGN})
	execute_process(
		COMMAND ${cmd}
		WORKING_DIRECTORY "${target}"
		OUTPUT_QUIET
	)
endfunction()
