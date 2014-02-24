function(obj_new result constructor )
	# compare to javascript new operator: 
	# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new

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

	# if constructor returns an object it will be the result of new
	if(instance)
		set(object ${instance})
	endif()
	#return the instance
	return_value(${object})
endfunction()