function(map_query result query)
	# get definitions
	string(STRIP "${query}" query)
	set(regex "(from .* in .*(,.* in .*)*)((where).*)")
	string(REGEX REPLACE "${regex}" "\\1" sources "${query}")

	# get query
	string(LENGTH "${sources}" len)
	string(SUBSTRING "${query}" ${len} -1 query)
	string(STRIP "${query}" query)


	# get query predicate and selection term
	string(REGEX REPLACE "where(.*)select(.*)" "\\1" where "${query}")
	string(REGEX REPLACE "where(.*)select(.*)" "\\2" select "${query}")
	string(STRIP "${where}" where)
	string(STRIP "${select}" select)
	string_split(where_parts "${where}" " ")

	#remove "from " from sources
	string(SUBSTRING "${sources}" 5 -1 sources)



	# callback function for map_foreach
	function(map_query_foreach_action)
		#print_locals()
		#message("${where_parts} = ${installed_pkg} + ${dependency_pkg}")
		map_format(current_where "${where_parts}")
		# return value
		if(${current_where})
			map_transform(selection "${select}")
			ref_append(${map_query_result} "${selection}")
		endif()

	endfunction()

	# create a ref where the result is stored
	ref_new(map_query_result)
	map_foreach(map_query_foreach_action "${sources}")
	
	# get the result
	ref_get(${map_query_result} res)
	ref_delete(${map_query_result})

	set(${result} "${res}" PARENT_SCOPE)
	
endfunction()