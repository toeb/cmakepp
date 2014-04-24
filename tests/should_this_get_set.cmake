function(should_thisgetset)
	obj_create(obj)
	obj_set(${obj} "val1" "32")
	obj_pushcontext(${obj})
		assert(32 EQUAL ${val1})
		this_set("val2" 100)

	obj_popcontext()
	
	obj_get(${obj}  "val2")
  ans(res)
	assert(100 EQUAL ${res})
endfunction()