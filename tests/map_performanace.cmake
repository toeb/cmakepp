function(test)

	foreach(i RANGE 1000)

		map_new()
    ans(map)
		map_set(${map} key "value1")
		map_get(${map} res key )
		map_delete(${map})
	endforeach()
endfunction()