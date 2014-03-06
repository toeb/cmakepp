function(test)


	obj_new(uut)
	obj_declarefunction(${uut} myfunc)
	function(${myfunc})
		return_result("hello ${name} ${ARGN}")	
	endfunction()

	obj_set(${uut} name Tobias)


	set(result)

	assert(NOT COMMAND boundfu22)
	obj_bindimportmember(${uut} myfunc boundfu22)

	assert(COMMAND boundfu22)
	boundfu22(muuu)
	result(res)
	assert(res)
	assert("${res}" STREQUAL "hello Tobias muuu")


endfunction()