
function(map_check this)
	map_exists(${this} )
  ans(res)
	if(NOT ${res})
		message(FATAL_ERROR "map '${this}' does not exist")
	endif()
endfunction()