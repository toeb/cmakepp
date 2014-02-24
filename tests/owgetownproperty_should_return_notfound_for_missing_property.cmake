function(owgetownproperty_should_return_notfound_for_missing_property)
	obj_create(res)
	obj_getownproperty(${res} val "val2")

	assert(${val} STREQUAL "NOTFOUND")
endfunction()