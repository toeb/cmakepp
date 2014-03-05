# set a value in the map
function(map_set this key value)
	#map_check(${this})
	map_has(${this}  has_key ${key})
	if(NOT has_key)
		map_keys(${this} keys)
		list(APPEND keys "${key}")
		set_property(GLOBAL PROPERTY "${this}" "${keys}")
	endif()

	set(property_ref "${this}_${key}")
	set_property(GLOBAL PROPERTY "${property_ref}" "${value}")
endfunction()