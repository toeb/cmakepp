function(obj_setownproperty this key )
 	obj_nullcheck(${this})
 	set(data ${ARGN})
 	if("${key}" STREQUAL "__call__")
 		obj_has(${this} res print)
 	endif()
 	file(WRITE "${this}/${key}" "${ARGN}")
 
 endfunction()