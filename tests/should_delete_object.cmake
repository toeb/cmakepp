function(should_delete_object)
return()
# todo implement for references
	obj_create(obj)
	obj_delete(${obj})
	is_object(res ${obj})
	assert(NOT res)
endfunction()