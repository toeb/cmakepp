# creates a and defines a function (with random name)
function(function_new )
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

	return_ref(id)
endfunction()