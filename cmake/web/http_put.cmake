# content may be a file or structured data
function(http_put url content)
	message(DEBUG LEVEL 8 "http_put called for '${url}'")
	message_indent_push()
	set(tmpfile)
	
	data("${content}")
	ans(content)

	if(NOT EXISTS "${content}")
		map_isvalid("${content}")
		ans(ismap)

		if(ismap)
			json_serialize("${content}")
			ans(content)
		endif()
		file_make_temporary( "${content}")
		ans(tmpfile)
		set(content "${tmpfile}")
	endif()



	file(UPLOAD "${content}" "${url}" LOG log ${ARGN})
	if(tmpfile)
		file(REMOVE ${tmpfile})
	endif()

	http_response_parse("${log}")
	ans(res)
	message(DEBUG LEVEL 8 FORMAT "http_put returned response code: {res.code}" )
	message_indent_pop()
	return_ref(res)
endfunction()