function(should_thisgetset)
	obj_create(obj)
	obj_set(${obj} "val1" "32")
	obj_pushcontext(${obj})
		assert(32 EQUAL ${val1})
		var("val2" 100)

	obj_popcontext()
	
	obj_get(${obj} res "val2")
	assert(100 EQUAL ${res})
endfunction()