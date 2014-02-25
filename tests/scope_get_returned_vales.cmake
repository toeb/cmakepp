function(test)
	function(fu23)
		#scope_clear()
		set(a 1)
		set(b 2)
		set(c 3)
		scope_elevate()
	endfunction()

	scope_begin_watch()
	fu23()
	scope_end_watch(values)
	map_print(${values})


	map_keys(${values} keys)
	list_to_string(keystring keys " ")
	assert(${keystring} STREQUAL "a b c")
	map_values(${values} vals ${keys})
	message(${vals})
	list_to_string(valstring vals " ")
	#assert(${valstring} STREQUAL "1 2 3")

 	
endfunction()