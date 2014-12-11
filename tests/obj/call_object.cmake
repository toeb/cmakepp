function(call_object)
	obj_new()
	ans(uut)

	obj_declarecalloperation(${uut} callFunc)
	function(${callFunc})
		return("return_value")
	endfunction()

	obj_call(${uut})
	ans(res)
	assert("${res}" STREQUAL "return_value")
endfunction()