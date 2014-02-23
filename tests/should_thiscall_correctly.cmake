function(should_thiscall)

	function(outer)


		function(inner1)
			this_set(var1 "hello1")
			message("hello ${var1} ${this}")
		endfunction()
		function(inner2)
			this_set(var2 "hello2")
		endfunction()
		

		this_bindcall(inner1)
		this_bindcall(inner2)



		

		assert(${var1} STREQUAL "hello1")
		assert(${var2} STREQUAL "hello2")


	endfunction()


	obj_create(obj)
	obj_bindcall(${obj} outer)


endfunction()