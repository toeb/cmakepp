function(test)
	

	function(ClassA)

	endfunction()

	function(ClassB)
		obj_new(base ClassA)
		this_set(__proto__ ${base})
	endfunction()
	obj_new(obj1 ClassA)
	obj_new(obj2 ClassB)

	obj_gettype(${obj1} res1)
	obj_gettype(${obj2} res2)

	assert(res1)
	assert(res2)

	assert("${res1}" STREQUAL "ClassA")
	assert("${res2}" STREQUAL "ClassB")

	obj_gethierarchy(${obj2} hier)
	message("hierarchy: ${hier}")
	assert(hier)
	list(FIND hier "ClassA" index)
	assert(index)
	assert(index GREATER -1)

	set(res)
	obj_istype(${obj2} res ClassA)
	assert(res)
endfunction()