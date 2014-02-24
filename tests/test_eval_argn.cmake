function(test_eval_argn)
	message(STATUS "this does not work because ARGN is evaluated differently to much")
	eval("function(fuuu result args) \n  set(\\\${result} \\\${args} PARENT_SCOPE) \n  endfunction()")

	assert(NOT res)
	fuuu(res "a;b;c")
	assert(res)
	list_to_string(res2 res " ")
	assert("${res2}" STREQUAL "a b c")

endfunction()