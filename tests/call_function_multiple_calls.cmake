function(test)
	
	function(f1 a)
		set(result "f1 ${a}" PARENT_SCOPE)
	endfunction()


	function(f2 a)
		set(result "f2 ${a}" PARENT_SCOPE)
	endfunction()

	call_function(f1 d)
	assert(${result} STREQUAL "f1 d")

	call_function(f2 c)
	assert(${result} STREQUAL "f2 c")

endfunction()