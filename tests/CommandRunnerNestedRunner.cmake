function(test)
	message(STATUS "fails on linux when cutil test all is called")

	obj_new( CommandRunner)
	ans(outer)
	obj_new( CommandRunner)
	ans(inner)

	function(innerCommand arg)
		return("innercommandresult ${arg}")
	endfunction()
	curry(obj_call("${inner}"))
	ans(inner_func)
	obj_callmember(${outer} AddCommandHandler test1 ${inner_func})

	obj_callmember(${inner} AddCommandHandler test2 innerCommand)

	obj_callmember(${outer} Run test1 test2 juha)

	ans(res)
	assert(res)
	assert(${res} STREQUAL "innercommandresult juha")
	

	
endfunction()
