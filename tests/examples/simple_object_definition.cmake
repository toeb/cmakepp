function(simple_object_definition)


	function(MyConstructor)
		# declare and implement toString
		proto_declarefunction(toString)
		function("${toString}" )
			this_import()
			return("${val1} ${val2}")
		endfunction()

		# set some initial values
		this_set(val1 "you")
		this_set(val2 "cool")
	endfunction()

	obj_new( MyConstructor)
	ans(obj)
	obj_new( MyConstructor)
	ans(obj2)
	assert(obj)
	assert(obj2)

	# change property of second object
	obj_set(${obj2} val1 "me")

	# call tostring for both objects
	obj_member_call(${obj} toString )
	ans(res)
	obj_member_call(${obj2} toString )
	ans(res2)

	assert(res)
	assert(res2)
	assert(${res} STREQUAL "you cool")
	assert(${res2} STREQUAL "me cool")
endfunction()