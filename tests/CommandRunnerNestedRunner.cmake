function(test)
	message(STATUS "fails on linux when cutil test all is called")

	obj_new(outer CommandRunner)
	obj_new(inner CommandRunner)

	function(innerCommand arg)
		return_result("innercommandresult ${arg}")
	endfunction()
	obj_callmember(${outer} AddCommandHandler test1 ${inner})
	obj_callmember(${inner} AddCommandHandler test2 innerCommand)

	obj_callmember(${outer} Run test1 test2 juha)

	result(result)
	assert(result)
	assert(${result} STREQUAL "innercommandresult juha")
	

	
endfunction()
