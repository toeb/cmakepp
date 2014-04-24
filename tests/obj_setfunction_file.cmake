function(obj_setfunction_file)
	obj_create(obj)
	file_make_temporary(res "function(tmp)\nset(result hello)\nendfunction()")
	
	obj_setfunction(${obj} "${res}")
	get_function_string(str "${res}")
	file(REMOVE ${res})
	obj_get(${obj}  "tmp" )
  ans(fuu)

	assert(fuu)
	assert(${fuu} STREQUAL "function(tmp)\nset(result hello)\nendfunction()")
endfunction()