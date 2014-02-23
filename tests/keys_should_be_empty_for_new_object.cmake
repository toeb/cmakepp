
	function(keys_should_be_empty_for_new_object)
		obj_create(obj)
		obj_getkeys(${obj} keys)
		assert(NOT keys)
	endfunction()