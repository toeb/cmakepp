function(test)
	function(InheritanceClassA)

	endfunction()

	function(InheritanceClassB)
		this_inherit(InheritanceClassA)
	endfunction()


	obj_new( InheritanceClassA)
	ans(obj1)
	obj_new( InheritanceClassB)
	ans(obj2)

	obj_gettype(${obj1} )
	ans(res1)
	obj_gettype(${obj2} )
	ans(res2)
	assert(res1)
	assert(res2)

	assert("${res1}" STREQUAL "InheritanceClassA")
	assert("${res2}" STREQUAL "InheritanceClassB")

	obj_gethierarchy(${obj2} )
	ans(hier)
	
	assert(hier)
	list(FIND hier "InheritanceClassA" index)
	assert(index)
	assert(index GREATER -1)

	set(res)
	obj_istype(${obj2}  InheritanceClassA)
	ans(res)
	assert(res)
endfunction()