

function(map_create result)

	while(true)
		make_guid(id)
		get_property(lookup GLOBAL PROPERTY "map_global_${id}")
		if(NOT lookup)
			break()
		endif()
	endwhile()

	return_value("map_global_${id}")
endfunction()