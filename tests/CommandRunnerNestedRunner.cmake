function(test)


	new( CommandRunner)
	ans(outer)
	new( CommandRunner)
	ans(inner)

	function(innerCommand arg)
		return("innercommandresult ${arg}")
	endfunction()

	
	call(outer.AddCommandHandler(test1 "${inner}"))
	call(inner.AddCommandHandler(test2 "innerCommand"))


call(outer.Run(test1 test2 juha))
	ans(res)

	assert(res)
	assert(${res} STREQUAL "innercommandresult juha")
	

	
endfunction()
