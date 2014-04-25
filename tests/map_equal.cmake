function(test)
	map_new()
  ans(uut)
	map_append(${uut} k1 a)
	map_append(${uut} k1 b)
	map_append(${uut} k1 c)
	
	map_append(${uut} k2 c)
	map_append(${uut} k2 c)

	map_append(${uut} k3 "asd asda asd")
	
	map_new()
  ans(uut2)
	map_append(${uut2} k2 c)
	map_append(${uut2} k2 c)
	map_append(${uut2} k1 a)
	map_append(${uut2} k1 b)
	map_append(${uut2} k1 c)
	

	map_append(${uut2} k3 "asd asda asd")
	

	map_equal(${uut} ${uut2})
	ans(res)
	assert(res)

	map_equal(${uut2} ${uut})
	ans(res)
	assert(res)

	map_set(${uut} k1 "ello")

	map_equal(${uut} ${uut2})
	ans(res)
	assert(NOT res)


	map_equal(${uut2} ${uut})
	ans(res)
	assert(NOT res)
endfunction()