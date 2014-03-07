function(map_equal result mapA mapB)

	map_keys(${mapA} keysA)
	map_keys(${mapB} keysB)

	list(SORT keysA)
	list(SORT keysB)

	list_equal(keys_equal keysA keysB)
	if(NOT keys_equal)
		return_value(false)
	endif()

	foreach(key ${keysA})
		map_get(${mapA} valA ${key})
		map_get(${mapB} valB ${key})
		list_equal(val_equal ${valA} ${valB})
		if(NOT val_equal)
			return_value(false)
		endif()
	endforeach()
	return_value(true)
endfunction()