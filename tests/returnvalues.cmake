function(test)
	

	function(inner)
		return_result("hello world")	
		
	
	endfunction()

	function(testfu)
		inner()
	endfunction()









	testfu()
	result()

	assert(${result} STREQUAL "hello world")



endfunction()