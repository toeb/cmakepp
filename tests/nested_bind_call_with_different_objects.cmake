function(nested_bind_call_different_objects)
	function(inner_func)
		assert(this)
		set(inner_ref ${this} PARENT_SCOPE)
	endfunction()

	function(outer_func)
		assert(this)
		obj_create(obj2)

		obj_bindcall(${obj2} inner_func)
		set(inner_ref ${inner_ref} PARENT_SCOPE)
		set(expected_inner_ref ${obj2} PARENT_SCOPE)
		set(outer_ref ${this} PARENT_SCOPE)
	endfunction()

	obj_create(obj)
	obj_bindcall(${obj} outer_func)

	assert(inner_ref)
	assert(outer_ref)
	assert(${outer_ref} STREQUAL ${obj})
	assert(${inner_ref} STREQUAL ${expected_inner_ref})
	
endfunction()