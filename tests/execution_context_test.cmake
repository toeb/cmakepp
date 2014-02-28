function(execution_context_test)
	set(test)
	set(this)
	# create an object
	obj_create(obj)
	assert(EXISTS ${obj})

	# set an object property
	obj_set(${obj} test hello)

	# check that 'this' and 'test are not loaded'
	assert(NOT this)
	assert(NOT test)


	peek_front("callstack" beforeContext)
	#push obj on context stack
	obj_pushcontext(${obj})
		# now this is bound to obj
		assert( this)
		assert( ${this} STREQUAL ${obj})
		# all properties of obj are loaded in current context
		assert(test)

		# setting a property with this_set should also add it to the current scope
		this_set(try1 "hello")
		assert(try1)
		assert(${try1} STREQUAL "hello")


		this_set(try2 "hello2 ${test}")
		assert(try2)
		assert(${try2} STREQUAL "hello2 hello")


		# create a child object
		obj_create(newobj)
		# set the obj's newobj property to ${newobj}
		this_set(newobj ${newobj})
		assert(newobj)

		# make sure that newobj was not bound
		assert(NOT ${newobj} STREQUAL ${this})


		# push the context of newobj to top of execution stack
		obj_pushcontext(${newobj})
			#now this is bound to newobj
			assert(${newobj} STREQUAL ${this})

			this_set(try1 "you too?")
			assert(${try1} STREQUAL "you too?")

			# go back to previous context
			obj_popcontext()

		# all previusly set properties should now be available again
		assert(${this} STREQUAL ${obj})
		assert(${try1} STREQUAL "hello")

		obj_popcontext()
	#this should be unset now

	#message("execution context test '${this}'")
	assert(${this} STREQUAL ${beforeContext})


	# check if all properties are correct
	obj_get(${obj} res test)
	assert(${res} STREQUAL "hello")


	obj_get(${obj} res newobj)
	obj_get(${newobj} res try1)
	assert(${res} STREQUAL "you too?")
	obj_get(${obj} res try1)
	assert(${res} STREQUAL "hello")

	obj_get(${obj} res try2)

	assert(${res} STREQUAL "hello2 hello")

endfunction()