function(obj_new result  )
	# compare to javascript new operator: 
	# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new
	
	if(${ARGC} GREATER 1)
		set(constructor ${ARGV1})
	else()
		set(constructor Object)
	endif()

	## special handling of Object
	if(${constructor} STREQUAL Object)
		get_property(Object GLOBAL PROPERTY Object)
		if(NOT Object)
			obj_create(Object)
			#message("obj_new: creating Object base class in '${Object}'")
			obj_create(ObjectProto)
			obj_setprototype(${Object} ${ObjectProto})
			get_function_string(func Object)
			obj_set(${Object} "__call__" "${func}")
			set_property(GLOBAL PROPERTY Object ${Object})
		endif()
		set(constructor ${Object})
	else()
		#ensure constructor is a functor
		obj_makefunctor(constructor "${constructor}")
	endif()


	#create the new object
	obj_create(object)
	obj_create(prototype)
	#object inherits prototype of functor
	obj_getprototype(${constructor} proto)
	obj_setprototype(${prototype} ${proto})
	obj_setprototype(${object} ${prototype})
	
	# bind new object to __call__ method of constructor functor
	


	set(instance)
	set(args ${ARGN})
	if(args)
		list(REMOVE_AT args 0)
	endif()

	set(call)
	obj_get(${constructor} call_constructor __call__)

	# constructor may return via global returning mechanism	

	obj_pushcontext(${object})
	import_function("${call_constructor}" as bound_function REDEFINE)

	bound_function(${args})
	obj_popcontext()


	#set objects constructor property to the constructor
	obj_set(${object} "__ctor__" ${constructor})

	# if constructor returns an object it will be the result of new
	if(instance)
		set(object ${instance})
	endif()
	#return the instance
	return_value(${object})
endfunction()