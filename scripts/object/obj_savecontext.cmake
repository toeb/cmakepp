function(obj_savecontext ctx)
	obj_getkeys(${ctx} keys)
	if(NOT keys)
		return()
	endif()
	foreach(key ${keys})
		#debug_message("saving ${key} to ${${key}}")
		obj_set(${ctx} "${key}" "${${key}}")
	endforeach()



endfunction()