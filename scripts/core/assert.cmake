function(assert)
	
	set(options LIST STRING NUMBER EQUALS CONTINUE ACCUMULATE)
  	set(oneValueArgs MESSAGE RESULT RESULT_LIST)
  	set(multiValueArgs EXPECTED ACTUAL)
  	set(prefix)
  	cmake_parse_arguments("${prefix}" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
	#_UNPARSED_ARGUMENTS


	# if message is not set add default message
	if(NOT _MESSAGE)
		set(_MESSAGE "assertion failed: '${_UNPARSED_ARGUMENTS}'")
	endif()



	if(NOT (${_UNPARSED_ARGUMENTS}))

		message(FATAL_ERROR "'${_MESSAGE}'  (caller: ${imported_caller_function_name})")
	endif()

	eval_truth(result ${_UNPARSED_ARGUMENTS})

	if(_RESULT )
		set(${_RESULT} ${result} PARENT_SCOPE)
	endif()
endfunction()