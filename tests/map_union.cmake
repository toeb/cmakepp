function(test)
	# creates two maps and merges them
	# create two maps
	 element(uut1)
	 	value(KEY k1 VALUE 1)
	 	value(KEY k2 VALUE 1)
	 element(END)

	 element(uut2)
	 	value(KEY k2 VALUE 2)
	 	value(KEY k3 VALUE 2)
	 element(END)


	#merge by overwriting map2 with map1
	 map_union(res ${uut2} ${uut1})
	 assert(res)
	 map_keys(${res} keys)
	map_tryget(${res} val k1)
	assert(${val} STREQUAL 1)

	map_tryget(${res} val k2)
	assert(${val} STREQUAL 1)

	map_tryget(${res} val k3)
	assert(${val} STREQUAL 2)

	# merge in oposite direction
	 map_union(res ${uut1} ${uut2})
	 assert(res)
	map_tryget(${res} val k1)
	assert(${val} STREQUAL 1)

	map_tryget(${res} val k2)
	assert(${val} STREQUAL 2)

	map_tryget(${res} val k3)
	assert(${val} STREQUAL 2)
endfunction()