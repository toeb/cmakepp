#navigates a map structure
# use '.' and '[]' operators to select next element in map
# e.g.  map_navigate(<map_ref> res "propa.propb[3].probc[3][4].propd")
function(map_navigate result navigation_expression)
	# path is empty => NOTFOUND
	if(navigation_expression STREQUAL "")
		return_value(NOTFOUND)
	endif()


	# split off reference from navigation expression
	unset(ref)
	string(REGEX MATCH "^[^\\[|\\.]*" ref "${navigation_expression}")
	string(LENGTH "${ref}" len )
	string(SUBSTRING "${navigation_expression}" ${len} -1 navigation_expression )


	# if ref is a ref to a ref dereference it :D 
	if(DEFINED ${ref})
		set(ref ${${ref}})
	endif()

	# check if ref is valid
	ref_isvalid(is_ref ${ref})
	if(NOT is_ref)
		message(FATAL_ERROR "map_navigate: expected a reference")
	endif()

	# match all navigation expression parts
	string(REGEX MATCHALL  "(\\[([0-9][0-9]*)\\])|(\\.[a-zA-Z0-9][a-zA-Z0-9]*)" parts "${navigation_expression}")
	
	# loop through parts and try to navigate 
	# if any part of the path is invalid return NOTFOUND
	set(current ${ref})
	foreach(part ${parts})
		string(REGEX MATCH "[a-zA-Z0-9][a-zA-Z0-9]*" index "${part}")
		string(SUBSTRING "${part}" 0 1 index_type)	
		if(index_type STREQUAL ".")
			# get by key
			map_tryget(${current} current "${index}")
		elseif(index_type STREQUAL "[")
			# get by index
			ref_get(lst ${current})
			list(GET lst ${index} keyOrValue)
			map_tryget(${current} current ${keyOrValue})
			if(NOT current)
				set(current ${keyOrValue})
			endif()
		endif()
		if(NOT current)
			return_value(NOTFOUND)
		endif()
	endforeach()

	# current  contains the navigated value
	return_value("${current}")
endfunction()
	