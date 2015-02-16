

# adds additional syntax to glob allowing exclusion by prepending a ! exclamation mark.
# e.g.
# file_extended_glob("dir" "**.cpp" "!build/**") 
# returns all cpp files in dir except if they are in the dir/build directory
function(file_extended_glob base_dir)
	set(args ${ARGN})
	list_extract_flag(args --relative)
	ans(relative)
	if(relative)
		set(relative --relative)
	endif()
	set(includes)
	set(excludes)
	foreach(current ${args})
		if("${current}" MATCHES "!.*")
			string(SUBSTRING "${current}" "1" "-1" current)
			list(APPEND excludes "${current}")
		else()
			list(APPEND includes "${current}")
		endif()
	endforeach()

	file_glob("${base_dir}" ${includes} ${relative})
	ans(includes)

	file_glob("${base_dir}" ${excludes} ${relative})
	ans(excludes)


	if(includes AND excludes)
		list(REMOVE_ITEM includes ${excludes})
	endif()

	return_ref(includes)
endfunction()