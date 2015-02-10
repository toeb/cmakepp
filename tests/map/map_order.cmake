function(test)
	message("test inconclusive")
	return()
	set(lst)

	element()
		value(KEY key val4)
	element(END v1)
	set(lst ${lst} ${v1})
	element()
		value(KEY key val2)
	element(END v2)
	set(lst ${lst} ${v2})
	element()
		value(KEY key val3)
	element(END v3)
	set(lst ${lst} ${v3})

	
	function(cmp_lst result a b)
	#message("${a} ${b}")
		map_get(${a}  key)
		ans(valA)
		map_get(${b}  key)
		ans(valB)
		if("${valA}" STRLESS "${valB}")
			return_value(-1)
		else()
			return_value(1)
		endif()
	endfunction()



	foreach(it ${lst})
		ref_print(${it})
	endforeach()
	map_order(lst cmp_lst)

	foreach(it ${lst})
		ref_print(${it})
	endforeach()

endfunction()