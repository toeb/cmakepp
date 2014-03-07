function(test)
	
	message(STATUS "fails on linux when cutil test all is called")
	obj_new(uut CommandRunner)

	function(myCommand)
		return_result(muha)
	endfunction()
	obj_callmember(${uut} AddCommandHandler test myCommand)

	obj_callmember(${uut} Run test)
	result(result)
	assert(result)
	assert(${result} STREQUAL "muha")



endfunction()