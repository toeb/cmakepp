#removes a item from the map identified by 'key'
function(map_remove map key)
  map_has("${map}" "${key}")
  ans(hasKey)
  if(NOT hasKey)
  	return(false)
  endif()
  map_set_hidden("${map}" "${key}" "")

	map_keys("${map}")
	ans(keys)
	if(NOT keys)
		return(false)
	endif()

	list(FIND keys "${key}" res)
	if(${res} LESS 0)
		return(false)
	endif()

	list(REMOVE_AT keys ${res})
	set_property(GLOBAL PROPERTY "${map}" ${keys})

	return(true)
endfunction()



	
