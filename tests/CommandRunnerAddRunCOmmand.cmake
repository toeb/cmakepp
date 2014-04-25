function(test)
	
	message(STATUS "fails on linux when cutil test all is called")
	obj_new( CommandRunner)
ans(uut)

	function(myCommand)
		return(muha)
	endfunction()
	obj_callmember(${uut} AddCommandHandler test myCommand)

	obj_callmember(${uut} Run test)
	ans(res)
	assert(res)
	assert(${res} STREQUAL "muha")



endfunction()