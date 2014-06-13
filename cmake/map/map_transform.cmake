function(map_transform  query)
	string(STRIP "${query}" query)
	string(FIND "${query}" "new" res)
	if(${res} EQUAL 0)

		string(SUBSTRING "${query}" 3 -1 query)
		json_deserialize( "${query}")
		ans(obj)

		function(map_select_visitor)
			list_isvalid(${current} )
			ans(islist)
			map_isvalid(${current} )
			ans(ismap)
			if(islist)
				ref_get(${current} )
				ans(values)
				set(transformed_values)
				foreach(value ${values})
					map_format( "${value}")
					ans(res)
					set(transformed_values "${transformed_values}" "${value}")
				endforeach()
				ref_set(${current} "${transformed_values}")
			elseif(ismap)
				map_keys(${current} )
				ans(keys)
				foreach(key ${keys})
					map_get(${current}  ${key})
					ans(value)
					map_format( "${value}")
					ans(res)
					map_set(${current} ${key} "${res}")
				endforeach()
			endif()
		endfunction()
		map_graphsearch(${obj} VISIT map_select_visitor)
		return_ref(obj)
	endif()

	set(res)
	map_format( "${query}")
	ans(res)
	return_ref(res)
endfunction()