# returns all keys for the specified object
function(obj_getkeys this result)
	obj_getownkeys(${this} ownkeys)
	set(proto)
	obj_getprototype(${this} proto)
	#message("1")
	if(proto)
		obj_getkeys(${proto} parentkeys)
	endif()
	set(keys ${ownkeys} ${parentkeys})

	list(LENGTH keys ctn)
	if(${ctn} LESS 1)
		return_value(NOTFOUND)
	endif()
	
	list(REMOVE_DUPLICATES keys )
	
	# remove hidden fields
	# this has to be more transparent
	#list(REMOVE_ITEM keys __ctor__ __call__ __proto__)

	debug_message("${this} has following keys ${keys} ")
	return_value(${keys})
endfunction()