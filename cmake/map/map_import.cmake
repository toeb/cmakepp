function(map_import map)
	set(prefix)
	if( ARGN)
		set(prefix "${ARGV1}_")	
	endif()

	map_check(${map})
	map_keys(${map} keys)

	foreach(key ${keys})
		map_get(${map} value ${key})
		set("${prefix}${key}" ${value} PARENT_SCOPE)
	endforeach()
endfunction()