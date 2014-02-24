function(nested_bind_call_sameobject)
		function(testfunc1)
			set(inner ${this} PARENT_SCOPE)
		endfunction()

		function(testfunc2)
			obj_bindcall(${this} testfunc1)
			set(inner ${inner} PARENT_SCOPE)
			set(outer ${this} PARENT_SCOPE)
		endfunction()

		obj_create(obj)
		obj_bindcall(${obj} testfunc2)

		assert(${inner} STREQUAL "${obj}")
		assert(${outer} STREQUAL "${obj}")
		assert(NOT this)
	endfunction()