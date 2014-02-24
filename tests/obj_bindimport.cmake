function(test)


	function(fu arg)

		set(result1 ${val} PARENT_SCOPE)
		set(result2 ${arg} PARENT_SCOPE)
		set(result3 ${this} PARENT_SCOPE)
		this_set(val2 "byebye")


	endfunction()

	obj_create(obj)
	obj_set(${obj} val "hrhr")
	obj_bindimport(${obj} fu boundfu)

	assert(NOT result1)
	assert(NOT result2)
	assert(NOT result3)
	boundfu(hello)
	assert(result1)
	assert(result2)
	assert(result3)
	assert(${result1} STREQUAL "hrhr")
	assert(${result2} STREQUAL "hello")
	assert(${result3} STREQUAL "${obj}")

	obj_get(${obj} res val2)
	assert(res)
	assert(${res} STREQUAL "byebye")

endfunction()