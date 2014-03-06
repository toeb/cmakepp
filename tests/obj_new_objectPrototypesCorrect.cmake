function(test)


	#print_locals()
	function(ClassAB)
		#message("protoA ${__proto__}")
		obj_declarefunction(${__proto__} methodA)
	endfunction()
	function(ClassBB)
		#message("protoB ${__proto__}")
		obj_declarefunction(${__proto__} methodB)
	endfunction()



	obj_new(objA ClassAB)

	obj_new(objB ClassBB)

	ref_print(${objA})
	ref_print(${objB})



	obj_has(${objA} AhasmethodA methodA)
	obj_has(${objA} AhasmethodB methodB)

	obj_has(${objB} BhasmethodA methodA)
	obj_has(${objB} BhasmethodB methodB)

	#obj_callmember(${objA} print)
	#obj_callmember(${objB} print)

	assert( AhasmethodA)
	assert(NOT AhasmethodB)
	assert(NOT BhasmethodA)
	assert( BhasmethodB)
endfunction()