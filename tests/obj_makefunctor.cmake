function(test)


	function(fu)
		set(result "hello" PARENT_SCOPE)
	endfunction()
	obj_makefunctor(functor fu)
	assert(functor)
	obj_callobject(${functor})
	assert(result)
	assert(${result} STREQUAL "hello")

endfunction()