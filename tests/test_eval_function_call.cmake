function(test_eval_function_call)

	function(myfunc result input)
		return_value("${input}")
	endfunction()

	set(res)
	assert(NOT res)
	eval("myfunc(res hello)")
	assert(res)
	assert(${res} STREQUAL "hello")

endfunction()