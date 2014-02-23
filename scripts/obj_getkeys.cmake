
function(obj_getkeys this result)
	obj_getownkeys(${this} ownkeys)
	obj_getprototype(${this} proto)
	if(proto)
		obj_getkeys(${proto} parentkeys)
	endif()
	set(keys ${ownkeys} ${parentkeys})

	list(LENGTH keys ctn)
	if(${ctn} LESS 1)
		return_value(NOTFOUND)
	endif()
	
	list(REMOVE_DUPLICATES keys )
	debug_message("${this} has following keys ${keys} ")
	return_value(${keys})
endfunction()