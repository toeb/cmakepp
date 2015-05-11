
function(message)
	cmake_parse_arguments("" "PUSH_AFTER;POP_AFTER;INFO;FORMAT;PUSH;POP" "" "" ${ARGN})
	## format
	if(_FORMAT)
		format("${_UNPARSED_ARGUMENTS}")
		ans(text)
	else()
		set(text ${_UNPARSED_ARGUMENTS})
	endif()


	## indentation
	if(_PUSH)
		message_indent_push()
	endif()
	if(_POP)
		message_indent_pop()
	endif()


	message_indent_get()
	ans(indent)
	if(_POP_AFTER)
		message_indent_pop()
	endif()
	if(_PUSH_AFTER)
		message_indent_push()
	endif()
	## end of indentationb




	list(GET text 0 modifier)
	if(${modifier} MATCHES "FATAL_ERROR|STATUS|AUTHOR_WARNING|WARNING|SEND_ERROR|DEPRECATION")
		list(REMOVE_AT text 0)
	else()
		set(modifier)
	endif()

	


	if(NOT text)
		return()
	endif()

	map_new()
	ans(message)
	map_set(${message} text "${text}")
	map_set(${message} indent_level ${message_indent_level})
	map_set(${message} mode "${modifier}")
	event_emit(on_message ${message})


	tock()

	## clear status line
	status_line_clear()
	_message(${modifier} "${indent}" "${text}")
	status_line_restore()

	
	return()
endfunction()


