function(obj_new result)

	set(constructor)
	if(${ARGC} GREATER 1)
		set(constructor ${ARGV1})
	else()
		set(constructor Object)
	endif()

	type_get(base ${constructor})
	obj_get(${base}  __init__)
	ans(constr)
	#message("constructor ${constructor} base ${base} const ${constr}")
	#ref_print(${base})
	obj_create(instance)


	obj_setprototype(${instance} ${base})


	set(args ${ARGN})
	if(args)
		list(REMOVE_AT args 0)
	endif()
	result_clear()
	obj_callmember(${instance} __init__ ${args})
	result(inst)
	if(inst)
		set(instance ${inst})
	endif()

	set(${result} ${instance} PARENT_SCOPE)

endfunction()