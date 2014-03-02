function(test)
	map_create(uut)
	map_append(${uut} k1 a)
	map_append(${uut} k1 b)
	map_append(${uut} k1 c)
	
	map_append(${uut} k2 c)
	map_append(${uut} k2 c)

	map_append(${uut} k3 "asd asda asd")
	
	map_create(uut2)
	map_append(${uut2} k2 c)
	map_append(${uut2} k2 c)
	map_append(${uut2} k1 a)
	map_append(${uut2} k1 b)
	map_append(${uut2} k1 c)
	

	map_append(${uut2} k3 "asd asda asd")
	

	map_equal(res ${uut} ${uut2})
	assert(res)

	map_equal(res ${uut2} ${uut})
	assert(res)

	map_set(${uut} k1 "ello")

	map_equal(res ${uut} ${uut2})
	assert(NOT res)


	map_equal(res ${uut2} ${uut})
	assert(NOT res)
endfunction()