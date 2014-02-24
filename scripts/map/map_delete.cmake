function(map_delete this)
	map_check(${this})
	map_keys(${this} keys)

	foreach(key ${keys})
		map_remove(${this} ${key})
	endforeach()
	set_property(GLOBAL PROPERTY ${this})
endfunction()