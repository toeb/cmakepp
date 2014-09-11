# compresses all files specified in glob expressions into ${target} tgz file
# paths are qualified using path() so using cd() before hand will keep folder structure
# usage: compress(<file> [<glob> ...]) - 
# 
function(compress target)
  set(args ${ARGN})
  
  # target file
  path("${target}")
  ans(target)

  # get current working dir
  pwd()
  ans(pwd)

  # get all files to compress
  file_glob("${pwd}" ${args})
  ans(paths)

  # compres all files into target using paths relative to pwd()
  tar(cvzf "${target}" ${paths})
  return_ans()



	# old implementation (will not be reached)
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