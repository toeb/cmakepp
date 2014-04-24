function(obj_setfunctiontest_simple)

	obj_create(obj)
	obj_setfunction(${obj} "function(testfu) \n endfunction()")
	obj_get(${obj}  testfu)
  ans(fu)
	assert(fu)
	assert(${fu} STREQUAL "function(testfu) \n endfunction()")
endfunction()