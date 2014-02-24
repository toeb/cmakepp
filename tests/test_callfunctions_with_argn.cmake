function(test_callfunctions_with_argn)
	message(STATUS "this will not work")
	return()
	call_function("function(thefunc result)\n set(result \"\${ARGN}\" PARENT_SCOPE)\n endfunction()" res arg1 arg2)

	list_to_string(str "${res}" " ")
	assert("arg1 arg2" STREQUAL "${str}")
endfunction()