function(obj_new result  )
	# compare to javascript new operator: 
	# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new
	
	if(${ARGC} GREATER 1)
		set(constructor ${ARGV1})
	endif()

	# hacked = this should go somewhere different - obj_typefind?  types should be registeredsomehow
	if(NOT constructor)
		get_property(types GLOBAL PROPERTY types)
		if(NOT types)
			map_create(types)
			set_property(GLOBAL PROPERTY ${types})
		endif()
		
		map_tryget(${types} Object Object)
		if(NOT Object)

			obj_newfunctor(Object Object)
			map_set(${types} Object ${Object})
		endif()
		set(constructor ${Object})
	endif()

	#ensure constructor is a functor
	obj_makefunctor(constructor ${constructor})
	#create the new object
	obj_create(object)
	#object inherits prototype of functor
	obj_getprototype("${constructor}" proto)
	obj_setprototype(${object} ${proto})

	# bind new object to __call__ method of constructor functor
	obj_get(${constructor} call __call__)
	obj_bindcall(${object} ${call} instance ${ARGN})

	#set objects constructor property to the constructor
	obj_set(${object} "__ctor__" ${constructor})

	# if constructor returns an object it will be the result of new
	if(instance)
		set(object ${instance})
	endif()
	#return the instance
	return_value(${object})
endfunction()