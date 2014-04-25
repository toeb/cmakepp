function(test)


	#print_locals()
	function(ClassAB)

		proto_declarefunction(methodA)
	endfunction()
	function(ClassBB)
		#message("protoB ${__proto__}")
		proto_declarefunction(methodB)
	endfunction()



	obj_new( ClassAB)
	ans(objA)

	obj_new( ClassBB)
	ans(objB)

	ref_print(${objA})
	ref_print(${objB})



	obj_has(${objA}  methodA)
	ans(AhasmethodA)
	obj_has(${objA}  methodB)
	ans(AhasmethodB)
	obj_has(${objB}  methodA)
	ans(BhasmethodA)
	obj_has(${objB}  methodB)
	ans(BhasmethodB)

	
	assert( AhasmethodA)
	assert(NOT AhasmethodB)
	assert(NOT BhasmethodA)
	assert( BhasmethodB)
endfunction()