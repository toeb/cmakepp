function(map_foreach _action _query)
	# import action function
	import_function("${_action}" as _map_foreach_action REDEFINE)

	# create a map that maps element name to container
	string_split(_query "${_query}" ",")
	element(MAP)
	foreach(_part ${_query})
		string(STRIP "${_part}" _part)
		string_split(_def_parts "${_part}" " in ")
		list(GET _def_parts 0 _name)
		list(GET _def_parts 1 _expr)
		value(KEY "${_name}" "${_expr}")
	endforeach()
	element(END _defs)

	#  setup bounds and indice list
	map_keys(${_defs} _def_keys)
	list(LENGTH _def_keys keys_length)
	set(_bounds)
	set(_indices)
	foreach(key ${_def_keys})
		map_get(${_defs} current_list ${key})
		list(LENGTH ${current_list} len)
		set(_bounds ${_bounds} ${len})
		set(_indices ${_indices} 0)
	endforeach()

	math(EXPR keys_length "${keys_length} -1")

	map_values(${_defs} _def_values ${_def_keys})

	# iterate through all combinations of values
	while(true)
		# set values
		set(current_values)
		foreach(i RANGE ${keys_length})
			list(GET _indices ${i} current_index)
			list(GET _def_keys ${i} current_key)
			list(GET _def_values ${i} current_list)
			list(GET ${current_list} ${current_index} current_value)
			set(current_values ${current_values} ${current_value})
			set(${current_key} "${current_value}")
		endforeach()

		# call action
		_map_foreach_action()

		# increment indices
		set(overflow true)
		foreach(i RANGE ${keys_length})
			if(NOT overflow)
				break()
			endif()
			set(overflow false)
			list(GET _bounds ${i} bound)
			list(GET _indices ${i} index)
			math(EXPR index "${index} + 1")
			if(NOT ${index} LESS ${bound})
				set(index 0)
				set(overflow true)
			endif()
			list_replace_at(_indices ${i} ${index})
		endforeach()
		if(overflow)
			break()
		endif()
	endwhile()
	set(${result} "${res}" PARENT_SCOPE)
endfunction()