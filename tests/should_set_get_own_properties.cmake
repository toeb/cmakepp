
	function(should_set_get_own_property)
		obj_create(obj)
		obj_setownproperty(${obj} "test1" "val")
		obj_getownproperty(${obj} res "test1")
		assert(res)
		assert(${res} STREQUAL "val")
	endfunction()