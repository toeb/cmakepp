function(test)

function(map_query result query)
	# get definitions
	string(STRIP "${query}" query)
	set(regex "(from .* in .*(,.* in .*)*)((where).*)")
	string(REGEX REPLACE "${regex}" "\\1" sources "${query}")

	# get query
	string(LENGTH "${sources}" len)
	string(SUBSTRING "${query}" ${len} -1 query)
	string(STRIP "${query}" query)

	# get query predicate
	string(REGEX REPLACE "where(.*)" "\\1" where "${query}")
	string(STRIP "${where}" where)
	string_split(where_parts "${where}" " ")

	# get definition parts
	string(SUBSTRING "${sources}" "5" "-1" parts)
	set(parts "${parts}")
	string_split(parts "${parts}" ",")

	element(MAP)
	foreach(part ${parts})
		string(STRIP "${part}" part)
		string_split(def_parts "${part}" " in ")
		list(GET def_parts 0 name)
		list(GET def_parts 1 expr)
		value(KEY "${name}" "${expr}")
	endforeach()
	element(END defs)

	ref_print(${defs})



	message("source: ${query}")	
	message("where: ${where}")

	map_keys(${defs} keys)
	list(LENGTH keys keys_length)

	set(bounds)
	set(indices)
	foreach(key ${keys})
		map_get(${defs}  current_list ${key})
		list(LENGTH ${current_list} len)
		set(bounds ${bounds} ${len})
		set(indices ${indices} 0)
	endforeach()
	message("${bounds} bounds ")
	message("${indices} indices")
	math(EXPR keys_length "${keys_length} -1")

	map_values(${defs} values ${keys})

		message("${keys}")
		message("${values}")
		set(res)
	while(true)
		# set values
		set(current_values)
		foreach(i RANGE ${keys_length})
			list(GET indices ${i} current_index)
			list(GET keys ${i} current_key)
			list(GET values ${i} current_list)
			list(GET ${current_list} ${current_index} current_value)
			set(current_values ${current_values} ${current_value})
			set(${current_key} "${current_value}")
		endforeach()


		set(current_where ";${where_parts};")
		foreach(source ${keys})
				string(REGEX MATCHALL "${source}[^ ]*" references "${where}")
				foreach(reference ${references})
					map_navigate(val "${reference}")
					string(REPLACE ";${reference};" ";${val};" current_where "${current_where}")
				endforeach()
		endforeach()

		# return value
		if(${current_where})
			element()
			foreach(key ${keys})
				value(KEY ${key} "${${key}}")
			endforeach()
			element(END val)
			set(res ${res} ${val})
		endif()

		# increment indices
		set(overflow true)
		foreach(i RANGE ${keys_length})
			if(NOT overflow)
				break()
			endif()
			set(overflow false)
			list(GET bounds ${i} bound)
			list(GET indices ${i} index)
			math(EXPR index "${index} + 1")
			if(NOT ${index} LESS ${bound})
				set(index 0)
				set(overflow true)
			endif()
			list_replace_at(indices ${i} ${index})
		endforeach()
		if(overflow)
			break()
		endif()
	endwhile()
	set(${result} "${res}" PARENT_SCOPE)
	return()
	string_split(where_parts "${where}" " ")

	set(res)
	foreach(${ref} ${${source}})
		messaGE("${ref} ref"  )
		string(REGEX MATCHALL "${ref}[^ ]*" references "${where}")
		set(current_where ${where_parts})
		foreach(reference ${references})
			map_navigate(val "${reference}")
			string(REPLACE ";${reference};" ";${val};" current_where ";${current_where}")
		endforeach()
		if(${current_where})
			set(res ${res} ${${ref}})
		endif()
	endforeach()	 

	set(${result} ${res} PARENT_SCOPE)
endfunction()

set(listA 1 2  3 4)
set(listB 1 3 5 3)
set(listC 1 4 4 3)
set(listD 1 5  5 5 3 )

#map_query(res "from a in listA, b in listB,c in listC, d in listD where a STREQUAL b AND b STREQUAL c AND d STREQUAL c ")
#foreach(r ${res})
#	ref_print(${r})
#endforeach()
#return()
function(map_select result query)
	string(STRIP "${query}" query)
	string(FIND "${query}" "new" res)
	if(${res} EQUAL 0)

		string(SUBSTRING "${query}" 3 -1 query)
		json_deserialize(obj "${query}")

		map_graphsearch(res ${obj})

		map_keys(${obj} keys)
		foreach(key ${keys})
			map_get(${obj} value ${key})
			map_select(res "${value}")
			#map_navigate(res "${value}")

			message("navigated: ${res}")
			map_set(${obj} "${key}" "${res}")
		endforeach()
		set(${result} "${obj}" PARENT_SCOPE)
		return()
	endif()

	set(res)
	map_format(res "${query}")
	set(${result} ${res} PARENT_SCOPE)
endfunction()


#return()
map_select(res "1")
assert("1" STREQUAL "${res}")

#map_select(res "\${ARGN}")
#assert("\${ARGN}" STREQUAL "${res}")

#set(var a)
#map_select(res "var")
#assert("a" STREQUAL "${res}")



element(MAP)
	value(KEY k1 v1)
	value(KEY k2 v2)
	value(KEY k3 v3)
	element(k4 LIST)
		value(1)
		value(2)
		value(3)
	element(END)
	element(k5 MAP)
		value(KEY k1 va)
		value(KEY k2 vb)
		value(KEY k3 vc)
	element(END)
element(END uut)

function(myvisit)
	ref_isvalid(${current} isref)
	if(NOT isref)
		return()
	endif()

	message("current is ${current}")
endfunction()
map_graphsearch(${uut} VISIT myvisit)


map_select(res "new { \"a\" : \"uut.k3\", \"b\" :  { \"a\" : \"uut.k4[0]\"}, \"c\": \"uut.k5.k2\"}")
ref_print(${res})

endfunction()