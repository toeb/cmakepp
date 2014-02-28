function(test)
	
	new_function(testfu)
	function(${testfu} result arg1 arg2)
		set(${result} "${arg1} ${arg2}" PARENT_SCOPE)
	endfunction()

	get_function_string(res ${testfu})

	message(${res})
endfunction()