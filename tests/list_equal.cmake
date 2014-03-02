function(test)
	# test to see if the two lists 1 2 3 are equal
	list_equal(res 1 2 3  1 2 3)
	assert(${res})


	list_equal(res "a;b;c"  "a;b;c")
	assert(${res})

	list_equal(res 1 2  1 2 3)
	assert(NOT ${res})

	# also works with passing variable value
	set(lst1 1 2 3)
	set(lst2 1 2 3)
	list_equal(res ${lst1} ${lst2})
	assert(${res})

	set(lst2 1 2 b )
	list_equal(res ${lst1} ${lst2})
	assert(NOT ${res})

	# also works with passing list references
	list_equal(res lst1 lst2)
	assert(NOT ${res})
endfunction()