function(test)
	message(STATUS "fails on linux when cutil test all is called")

	obj_new( CommandRunner)
	ans(outer)
	obj_new( CommandRunner)
	ans(inner)

	function(innerCommand arg)
		return("innercommandresult ${arg}")
	endfunction()
	obj_callmember(${outer} AddCommandHandler test1 ${inner})
	obj_callmember(${inner} AddCommandHandler test2 innerCommand)

	obj_callmember(${outer} Run test1 test2 juha)

	result(result)
	assert(result)
	assert(${result} STREQUAL "innercommandresult juha")
	

	
endfunction()
