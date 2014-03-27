# set a value in the map
function(map_set this key )
	#map_check(${this})
	map_has(${this} has_key ${key})
	if(NOT has_key)
		#map_keys(${this} keys)
		#list(APPEND keys "${key}")
		set_property(GLOBAL APPEND PROPERTY "${this}" "${key}")
	endif()

	# set the properties value
	set(property_ref "${this}_${key}")
	set_property(GLOBAL PROPERTY "${property_ref}" "${ARGN}")
	
endfunction()