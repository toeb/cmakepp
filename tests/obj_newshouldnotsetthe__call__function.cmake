function(test)
	# a vanilla object should not have __call__defined
	obj_new(obj)
	obj_has(${obj} res __call__)
	assert(NOT res)

	# a typed object should not have __call__ defined
	function(MyClass)
	endfunction()
	obj_new(obj MyClass)
	obj_has(${obj} res __call__)
	assert(NOT res)

	# a type inheriting from a callable object should not define __call__
	function(FunctorClass)
		function(fu)
		endfunction()
		obj_set(${__proto__} __call__ fu)
	endfunction()

	function(FunctorInheritingClass)
		obj_new(base FunctorClass)
		this_set(__proto__ ${base})
	endfunction()

	obj_new(obj FunctorInheritingClass)
	obj_has(${obj} res __call__)
	assert( res)
	obj_hasownproperty(${obj} res __call__)
	assert(NOT res)



endfunction()