function(simple_object_definition)


	function(MyConstructor)
		# declare and implement toString
		obj_declarefunction(${__proto__} toString)
		function("${toString}" result)
			return_value("${val1} ${val2}")
		endfunction()

		# set some initial values
		this_set(val1 "you")
		this_set(val2 "cool")
	endfunction()

	obj_new(obj MyConstructor)
	obj_new(obj2 MyConstructor)
	assert(obj)
	assert(obj2)

	# change property of second object
	obj_set(${obj2} val1 "me")

	# call tostring for both objects
	obj_callmember(${obj} toString res)
	obj_callmember(${obj2} toString res2)

	assert(res)
	assert(res2)
	assert(${res} STREQUAL "you cool")
	assert(${res2} STREQUAL "me cool")
endfunction()