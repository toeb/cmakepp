function(test)
	function(TestClass)
		obj_declarefunction(${__proto__} test)
		function(${test} result )
			set(${result} "hello ${ARGN}" PARENT_SCOPE)
		endfunction()
	endfunction()

	obj_new(uut TestClass)

	obj_callmember(${uut} test res hello)
	assert(res)
	assert(${res} STREQUAL "hello hello")
endfunction()