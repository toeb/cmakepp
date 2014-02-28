function(test)



	obj_new(obj)
	obj_set(${obj} "Name" Tobias)
	obj_declarefunction(${obj} fufu)
	function(${fufu} result)

		set(${result} "Hello ${Name} ${ARGN}" PARENT_SCOPE)
	endfunction()


	obj_bindmember(boundfu ${obj} "fufu")

	call_function(${boundfu} res "bar")
	assert(res)
	assert(${res} STREQUAL "Hello Tobias bar")

endfunction()