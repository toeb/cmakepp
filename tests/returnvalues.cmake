function(test)
	function(inner)
		return_result("hello world")	
	endfunction()

	function(testfu)
		inner()
	endfunction()

	testfu()
	result(res)

	assert("${res}" STREQUAL "hello world")
endfunction()