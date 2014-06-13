# orders the specified lst by applying the comparator
function(map_order _lst comparator)
	function_import("${comparator}" as map_sort_comparator REDEFINE)
	set(_i 0)
	set(_j 0)
	list(LENGTH ${_lst} _len)
	math(EXPR _len "${_len} -1")
	# slow sort
	while(true)
		if(NOT (${_i} LESS ${_len}))

			break()
		endif()
		list(GET ${_lst} ${_i} _a)
		list(GET ${_lst} ${_j} _b)
		map_sort_comparator(_res ${_a} ${_b})
		
		if(_res GREATER 0)
			list_swap(${_lst} ${_i} ${_j})
		endif()

		math(EXPR _j "${_j} + 1")
		if(${_j} GREATER ${_len})
			math(EXPR _i "${_i} + 1")
			math(EXPR _j "${_i} + 1")
		endif()

	endwhile()
	
	set(${_lst} ${${_lst}} PARENT_SCOPE)
endfunction()