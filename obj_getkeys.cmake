
function(obj_getkeys ref result)
	obj_getownkeys(${ref} ownkeys)
	obj_getprototype(${ref} proto)
	return_value(${keys})
endfunction()