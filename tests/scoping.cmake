function(scoping)
	
	#print_locals()
	
	function(test)
		scope_push()
		set(a "helo")
		set(b "helo")
		scope_elevate()
		scope_pop()
	endfunction()

	scope_clear()
	print_locals()
	message("    ")

	test()

	print_locals()


endfunction()