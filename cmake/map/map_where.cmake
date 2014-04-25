# query a a list of maps with linq like syntax
# ie  from package in packages where package.id STREQUAL package1 AND package.version VERSION_GREATER 1.3
# packages is a list of maps and package is the name for a single pakcage used in the where clause
# 
function(map_where  query)
	set(regex "from (.*) in (.*) where (.*)")
	string(REGEX REPLACE "${regex}" "\\1" ref "${query}")
	string(REGEX REPLACE "${regex}" "\\2" source "${query}")
	string(REGEX REPLACE "${regex}" "\\3" where "${query}")
	string_split( "${where}" " ")
	ans(where_parts)
	set(res)
	foreach(${ref} ${${source}})
		map_format( "${where_parts}")
		ans(current_where)
		if(${current_where})
			set(res ${res} ${${ref}})
		endif()
	endforeach()	 
	return_ref(res)
endfunction()