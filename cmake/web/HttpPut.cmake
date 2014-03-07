
function(HttpPut response url content)
	set(tmpfile)
	if(NOT EXISTS "${content}")
		file_make_temporary(tmpfile "${content}")
		set(content "${tmpfile}")
	endif()

	file(UPLOAD "${content}" "${url}" LOG log ${ARGN})
	if(tmpfile)
		file(REMOVE ${tmpfile})
	endif()

	ParseHttpResponse(res "${log}")
	set(${response} ${res} PARENT_SCOPE)
endfunction()