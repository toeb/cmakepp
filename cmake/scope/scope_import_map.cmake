# creates a local variable for every key value pair in map
# if the optional prefix is given this will be prepended to the variable name
function(scope_import_map map)
	set(prefix)
	set(args ${ARGN})
	list_pop_front(args)
	ans(prefix)

	map_keys(${map})
	ans(keys)

	foreach(key ${keys})
		map_tryget(${map}  ${key})
		ans(value)
		set("${prefix}${key}" ${value} PARENT_SCOPE)
	endforeach()
endfunction()