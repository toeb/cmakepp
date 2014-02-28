function(test)

	function(ClassA)
		#message("protoA ${__proto__}")
		obj_declarefunction(${__proto__} methodA)
	endfunction()
	function(ClassB)
		#message("protoB ${__proto__}")
		obj_declarefunction(${__proto__} methodB)
	endfunction()

	obj_new(objA ClassA)
	obj_new(objB ClassB)



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