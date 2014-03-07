function(test)
	function(InheritanceClassA)

	endfunction()

	function(InheritanceClassB)
		this_inherit(InheritanceClassA)
	endfunction()


	obj_new(obj1 InheritanceClassA)
	obj_new(obj2 InheritanceClassB)

	obj_gettype(${obj1} res1)
	obj_gettype(${obj2} res2)
	assert(res1)
	assert(res2)

	assert("${res1}" STREQUAL "InheritanceClassA")
	assert("${res2}" STREQUAL "InheritanceClassB")

	obj_gethierarchy(${obj2} hier)
	
	assert(hier)
	list(FIND hier "InheritanceClassA" index)
	assert(index)
	assert(index GREATER -1)

	set(res)
	obj_istype(${obj2} res InheritanceClassA)
	assert(res)
endfunction()