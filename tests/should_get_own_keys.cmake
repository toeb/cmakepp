
	function(should_get_own_keys)
		obj_create(obj)
		obj_setownproperty(${obj} "test1" "a")
		obj_setownproperty(${obj} "test2" "a")
		obj_setownproperty(${obj} "test3" "a")

		obj_getkeys(${obj} keys)
		assert(keys)
		list_to_string(keys keys " ")
		assert("${keys}" STREQUAL "test1 test2 test3")

	endfunction()