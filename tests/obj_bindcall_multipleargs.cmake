function(test)

	new_function(testfu)
	function(${testfu} result arg1 arg2)
		set(${result} "${arg1} ${arg2}" PARENT_SCOPE)
	endfunction()

	#get_function_string(res ${testfu})
	obj_create(obj)

	#foreach(i RANGE 100)
	obj_bindcall(${obj} "${testfu}" res2 a b)
 	#endforeach()
 	assert(${res2} STREQUAL "a b")
endfunction()