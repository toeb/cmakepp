function(test)
	return()
	### using objects
	### =============
	# oo-cmake is very similar to javascript
	# I actually used the javascript reference to figure out how things could be done :)
	# oo-cmake is a pure object oriented language like javascript (only objects no types per se)
	# oo-cmake is currently file based and relies heavily on dynamic functions to be upfron about it:
	# oo-cmake is very slow (depending on what your doing)

	## creating a object
	## =================
	obj_new()
	ans(myobject)
	# ${myobject} now is a reference to an object
	obj_exists(${myobject} _exists)
	assert(myobject)

	## deleting a object
	## =================
	# oo-cmake does not contains automatic memory management
	# you can however remove all objects by calling obj_cleanup 
	# (a very crude way of garbage collection) I would suggest calling it at the end of cmake.
	obj_new()
	ans(object_to_delete)
	obj_delete(${object_to_delete})
	# object_to_delete still contains the same reference
	# but the object does not exists anymore and the following returns false
	#obj_exists(${object_to_delete} _exists)
	#assert(NOT _exists)


	## setting and setting property
	## ==================
	obj_new()
	ans(myobject)
	# call obj_set passing the object reference
	# the propertyname 'key1' and the value 'val1'
	# everything beyond 'key1' is saved (as a list)
	obj_set(${myobject} key1 "val1")
	#call obj_get passing the object refernce the result variable and
	# the key which is to be gotten
	obj_get(${myobject}  key1)
	ans(theValue)
	assert(theValue)
	assert(${theValue} STREQUAL "val1")


	## setting a function and calling it
	## =================================
	obj_new()
	ans(obj)
	obj_set(${obj} last_name "Becker")
	obj_set(${obj} first_name "Tobias")
	#obj_setfunction accepts any function (cmake command, string function, file function, unique function (see function tutorial))
	# if you use a cmake function be sure that it will not be overwritten
	# the safest way to add a function is to use obj_declarefunction
	# you can either specify the key where it is to be stored or not
	# if you do not specify it the name of the function is used
	function(greet result)
		# in the function you have read access to all fields of the proeprty
		# as will as to 'this' which contains the reference to the object

		# this sets the variable ${result} in PARENT_SCOPE (returning values in cmake)
		set(${result} "Hello ${first_name} ${last_name}!" PARENT_SCOPE)

	endfunction()
	obj_setfunction(${obj} greet)
	obj_member_call(${obj} greet res)
	assert(res)
	assert(${res} STREQUAL "Hello Tobias Becker!")
	# alternatively you can also use obj_declarefunction
	# this is actually the easiest way to define a function in code
	obj_declarefunction(${obj} say_goodbye)
	function(${say_goodbye} result)
		set(${result} "Goodbye ${first_name} ${last_name}!" PARENT_SCOPE)
	endfunction()
	obj_member_call(${obj} say_goodbye res)
	assert(res)
	assert(res STREQUAL "Goodbye Tobias Becker!")

	## built in methods
	## ================
	# obj_new creates a object which automatically inherits Object
	# Object contains some functions e.g. to_string, print, ...
	# 
	obj_new()
	ans(obj)
	obj_member_call(${obj} print)

	# this prints all members
	# ie
	#{
	# print: [function], 
	# to_string: [function], 
	# __ctor__: [object :object_Y3dVWkChKi], 
	# __proto__: [object :object_AztQwnKoE7], 
	#}


	## constructors
	## ============
	# you can easily define a object type via constructor
	function(MyObject)
		# declare a function on the prototype (which is accessible for all objects)
		# inheriting from MyObject
		obj_declarefunction(${__proto__} myMethod)
		function(${myMethod} result)
			set(${result} "myMethod: ${myValue}" PARENT_SCOPE)
			this_set(myNewProperty "this is a text ${myValue}")
		endfunction()

		# set a field for the object
		this_set(myValue "hello")
	endfunction()

	obj_new( MyObject)
	ans(obj)
	# type of object will now be MyObject
	obj_gettype(${obj} )
	ans(type)
	assert(type)
	assert(${type} STREQUAL MyObject)
	# call
	obj_member_call(${obj} myMethod res)
	assert(res)
	assert(${res} STREQUAL "myMethod: hello")
	obj_set(${obj} myValue "othervalue")
	obj_member_call(${obj} myMethod res)
	assert(res)
	assert(${res} STREQUAL "myMethod: othervalue")
	obj_get(${obj}  myNewProperty)
	ans(res)
	assert(res)
	assert(${res} STREQUAL "this is a text othervalue")

	## functors
	## ========

	## binding a function
	## ==================
	# you can bind any function to an object without
	# setting it as property
	# causing the function to get access to 'this'
	# and all defined properties
	function(anyfunction)
		this_callmember(print)
	endfunction()
	obj_new()
	ans(obj)
	# bind function
	obj_pushcontext(${obj})
	anyfunction()
	obj_popcontext()
	#obj_bindcall(${obj} anyfunction)
	## print the object
	# alternatively you can bind the function to the object
	obj_bind(boundfu ${obj} anyfunction)
	call_function(${boundfu})
	# prints the object
	# alternatively you can bind and import then function
	# beware that you might overwrite a defined function if you append REDEFINE
	# 
	obj_bindimport(${obj} anyfunction myBoundFunc REDEFINE)
	myBoundFunc()
	# print the object



	## extended a 'type'
	## =================

endfunction()