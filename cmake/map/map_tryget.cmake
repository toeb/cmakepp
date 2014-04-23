# tries to get the value map[key] and returns NOTFOUND if
# it is not found
function(map_tryget map result key)
  get_property(res GLOBAL PROPERTY "${map}.${key}")
  set(${result} ${res} PARENT_SCOPE)
  return_ref(res)
  return()
	map_has(${map} res ${key})
	if(NOT res)
		return_value(NOTFOUND)
	endif()
	map_get(${map} res ${key})
	set(${result} "${res}" PARENT_SCOPE)
endfunction()