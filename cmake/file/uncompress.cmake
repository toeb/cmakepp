# uncompresses the file specified into the current pwd()
function(uncompress file)
  path("${file}")
  ans(file)
  tar(xzf "${file}")
  return_ans()

  # old implementation
  file(MAKE_DIRECTORY "${target}")
	set(cmd  ${CMAKE_COMMAND} -E tar xzf "${file}")
	execute_process(
		COMMAND ${cmd}
		WORKING_DIRECTORY "${target}"		
		OUTPUT_QUIET
	)
endfunction()