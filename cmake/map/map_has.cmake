function(map_has this result key )
  
  get_property(res GLOBAL PROPERTY "${this}_${key}" SET)
	if(res)
    return_value(true)
  endif()
  return_value(false)
  

  #map_check(${this})
	map_keys(${this} keys)
	list(FIND keys "${key}" res)
	if(${res} LESS 0)
		return_value(false)
	else()
		return_value(true)
	endif()
endfunction()
