function(test)
	## assert allows assertion

function(list_equal result)

endif()




function(assert)
	# parse arguments
	set(options STRING NUMBER EQUALS ACCUMULATE)
  	set(oneValueArgs MESSAGE RESULT MESSAGE_TYPE)
  	set(multiValueArgs EXPECTED ACTUAL)
  	set(prefix)
  	cmake_parse_arguments("${prefix}" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
	#_UNPARSED_ARGUMENTS
	set(result)



	# if continue is set set the mesype to statussage t
	if(_CONTINUE)
		set(_MESSAGE_TYPE STATUS)
	endif()

	#if no message type is set set FATAL_ERROR
	# so execution halts on failing assertion
	if(NOT _MESSAGE_TYPE)
		set(_MESSAGE_TYPE FATAL_ERROR)
	endif()

	# 
	if(_EQUALS)
		# list equals
		list(LENGTH _UNPARSED_ARGUMENTS count)
		math(EXPR single_count "${count} / 2")
		math(EXPR is_even "${single_count} % 2")
		if(NOT ${is_even} EQUAL "0")
			set(result false)
		else()

			set(comparator "STREQUAL")
			if(_NUMBER)
				set(comparator "EQUAL")
			endif()
		endif()

	else()
		# if nothing else is specified use _UNPARSED_ARGUMENTS as a truth expresion
		eval_truth(result (${_UNPARSED_ARGUMENTS}))
	endif()

	set(${_RESULT} ${result} PARENT_SCOPE)
	
	# if message is not set add default message
	if(NOT DEFINED _MESSAGE)
		set(_MESSAGE "assertion failed: '${_UNPARSED_ARGUMENTS}'")
	endif()

	if(NOT result)
		message(${_MESSAGE_TYPE} "'${_MESSAGE}'")
	endif()
endfunction()

# assert boolean value and continue 
assert(false MESSAGE "should be true" CONTINUE RESULT res)
assert(NOT res)


#assert boolean value 
assert(true MESSAGE "should be true" CONTINUE RESULT res)
assert(res)


# assert false truth expression
assert("asd" STREQUAL "bsd" CONTINUE RESULT res)
assert(NOT res)

# assert true truth expression
assert("asd" STREQUAL "asd" CONTINUE RESULT res)
assert(res)

# assert false equality
assert(EQUALS asd bsd CONTINUE RESULT res )
assert(NOT res)

#assert true equality
assert(EQUALS asd asd CONTINUE RESULT res)
assert(res)


## assert list equality true

# you can specify both lists inline
assert(EQUALS 1 2 3 4 1 2 3 4 CONTINUE RESULT res)
assert(res)

# you can specifiy the list a string
assert(EQUALS "1;2;3;4" "1;2;3;4" CONTINUE RESULT res)
assert(res)

# you can pass the list by reference
set(listA 1 2 3 4)
set(listB 1 2 3 4)
assert(EQUALS listA listB CONTINUE RESULT res)
assert(res)

## assert list equality false
assert(EQUALS 1 2 3 4 2 2 3 4 CONTINUE RESULT res)
assert(NOT res)

assert(EQUALS "1;2;3;4" "2;3;4;4" CONTINUE RESULT res)
assert(NOT res)

set(listA 1 2 3 4)
set(listB 1 2 3 3)
assert(EQUALS listA listB CONTINUE RESULT res)
assert(NOT res)




endfunction()