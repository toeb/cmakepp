# creates a and defines a function (with random name)
function(new_function result)
	#generate a unique function id
	make_guid(id)

	while(TRUE)
		make_guid(id)
		set(id "func_${id}")
		if(NOT COMMAND "${id}")
			break()
		endif()
	endwhile()

	#declare function
	function("${id}")
		message(FATAL_ERROR "function is declared, not defined")
	endfunction()

	return_value("${id}")
endfunction()