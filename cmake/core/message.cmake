
function(message)
	cmake_parse_arguments("" "PUSH_AFTER;POP_AFTER;DEBUG;INFO;FORMAT;JSON;PUSH;POP;POP_LEVEL" "PUSH_LEVEL;LEVEL;ADD_LISTENER;REMOVE_LISTENER" "" ${ARGN})

	map_tryget(global message_listeners)
	ans(message_listeners)
	if(_ADD_LISTENER)	
		ref_isvalid(${_ADD_LISTENER})
		ans(isref)
		if(NOT isref)
			list_new()
			ans(ref)
			set(${_ADD_LISTENER} ${ref} PARENT_SCOPE)
			set(_ADD_LISTENER ${ref})
		endif()

		map_append(global message_listeners ${_ADD_LISTENER})
	endif()
	if(_REMOVE_LISTENER)
		list(REMOVE_ITEM message_listeners ${_REMOVE_LISTENER})
		map_set(global message_listeners ${message_listeners})
	endif()

	map_tryget(global message_indent_level)
	ans(message_indent_level)
	
	if(NOT message_indent_level)
		set(message_indent_level 0)
	endif()
	if(_PUSH)
		math(EXPR message_indent_level "${message_indent_level} + 1")	
		map_set(global message_indent_level ${message_indent_level})
	endif()
	if(_POP)
		if(message_indent_level GREATER 0)
			math(EXPR message_indent_level "${message_indent_level} - 1")	
			map_set(global message_indent_level ${message_indent_level})	
		endif()
	endif()


	set(indent)
	foreach(i RANGE ${message_indent_level})
		set(indent "${indent}  ")
	endforeach()
	if(_POP_AFTER)
		if(message_indent_level GREATER 0)
			math(EXPR message_indent_level "${message_indent_level} - 1")	
			map_set(global message_indent_level ${message_indent_level})	
		endif()
	endif()
	if(_PUSH_AFTER)
		math(EXPR message_indent_level "${message_indent_level} + 1")	
		map_set(global message_indent_level ${message_indent_level})
		
	endif()
	string(SUBSTRING "${indent}" 2 -1 indent)
	if(NOT _UNPARSED_ARGUMENTS)
		return()
	endif()


	if(_DEBUG)
		if(NOT _LEVEL)
			set(_LEVEL 3)
		endif()
		set(_UNPARSED_ARGUMENTS STATUS ${_UNPARSED_ARGUMENTS})
	endif()
	if(_INFO)
		if(NOT _LEVEL)
			set(_LEVEL 2)
		endif()
		set(_UNPARSED_ARGUMENTS STATUS ${_UNPARSED_ARGUMENTS})
	endif()
	if(NOT _LEVEL)
		set(_LEVEL 0)
	endif()

	if(NOT MESSAGE_LEVEL)
		set(MESSAGE_LEVEL 3)
	endif()

	list(GET _UNPARSED_ARGUMENTS 0 modifier)
	if(${modifier} MATCHES "FATAL_ERROR|STATUS|AUTHOR_WARNING|WARNING|SEND_ERROR")
		list(REMOVE_AT _UNPARSED_ARGUMENTS 0)
	else()
		set(modifier)
	endif()


	set(msg "${_UNPARSED_ARGUMENTS}")
	if(_FORMAT)
		map_format( "${msg}")
		ans(msg)
	endif()

	if(_JSON)
		json_serialize( "${msg}" INDENTED)
		ans(res)
		set(msg ${res})
	endif()

	list(LENGTH msg arg_len)
	if(arg_len EQUAL 1)
		ref_isvalid("${msg}")
		ans(isref)
			if(isref)
			json_indented(${msg})
			ans(msg)
		endif()
	endif()


	if(NOT MESSAGE_DEPTH )
		set(MESSAGE_DEPTH -1)
	endif()

	if(NOT msg)
		return()
	endif()

	foreach(listener ${message_listeners})
		ref_append(${listener} ${modifier} "${msg}")

	endforeach()

	if(_LEVEL GREATER MESSAGE_LEVEL)
		return()
	endif()
	if(MESSAGE_QUIET)
		return()
	endif()
	# check if deep message are to be ignored
	if(NOT MESSAGE_DEPTH LESS 0)
		if(${message_indent_level} GREATER ${MESSAGE_DEPTH})
			return()
		endif()
	endif()

	tock()
	
	_message(${modifier} "${indent}" "${msg}")


	

endfunction()