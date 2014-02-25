# a helper for setting a function
# accepts a object reference and a function or a object reference a key and a function
# if only this and the function is provided the function name will be used as key
# else the specified key is used
# example:
# obj is a object reference
# function(func arg)
# message("${hello} world")
# endfunction()
# obj_setfunction(${obj} func)
# obj_callmember(${obj} func hello)
# result:
# hello world
function(obj_setfunction this)
	set(args ${ARGN})
	list(LENGTH args argc)
	if(${argc} EQUAL 0)
		message(FATAL_ERROR "expected a function to set")
	endif()
	if(${argc} EQUAL 1)
		get_function_string(func "${ARGV1}")
		parse_function(func "${func}")
		set(key "${func_name}")
	
	elseif(${argc} EQUAL 2)
		get_function_string(func "${ARGV2}")
		set(key "${ARGV1}")
	endif()
	#message("obj_setfunction: ${this} ${key} ${func}")
	obj_set(${this} ${key} "${func}")	
endfunction()