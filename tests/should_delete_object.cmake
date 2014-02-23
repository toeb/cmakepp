
	function(should_delete_object)
		obj_create(obj)
		obj_delete(${obj})
		is_object(res ${obj})
		assert(NOT res)
	endfunction()