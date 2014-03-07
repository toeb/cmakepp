# removes the top scope from the scope stack
# sets all values in current scope
macro(scope_pop)
	pop_front(scopes scope)
	map_keys(${scope} keys)
	foreach(key ${keys})
		map_get(${scope} val ${key})
		set(${key} ${val})
	endforeach()
	map_delete(${scope})
	set(scope)
	set(key)
	set(val)
endmacro()