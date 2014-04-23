# creates a union from all all maps passed as ARGN and combines them in result
# you can merge two maps by typing map_union(${map1} ${map1} ${map2})
# maps are merged in order ( the last one takes precedence)
function(map_merge result)
	set(lst ${ARGN})
	
	set(res ${${result}})
	if(NOT res)
		map_new()
    ans(res)
	endif()
	foreach(map ${lst})
		map_keys(${map} keys)
		foreach(key ${keys})
			map_tryget(${res} existing_val ${key})
			map_tryget(${map} val ${key})

			map_isvalid("${existing_val}" existing_ismap)
			map_isvalid("${val}" new_ismap)

			if(new_ismap AND existing_ismap)
				map_union(existing_val  ${val})
			else()
				
				map_set(${res} ${key} ${val})
			endif()
		endforeach()
	endforeach()
	return_value(${res})
endfunction()

