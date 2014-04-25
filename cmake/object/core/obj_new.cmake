function(obj_new)
	set(args ${ARGN})
	list_pop_front( args)
	ans(constructor)
	if(NOT COMMAND "${constructor}")
		set(constructor Object)
	endif()

	type_get(${constructor})
	ans(base)
	map_get_special(${base} constructor)
	ans(constr)

	map_new()
	ans(instance)

	obj_setprototype(${instance} ${base})


	

	obj_callmember(${instance} __constructor__ ${args})
	ans(res)
	if(res)
		set(instance "${res}")
	endif()
	return_ref(instance)
endfunction()