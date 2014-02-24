function(stringescape )
	return()
	function(inner arg)

		message("arg" ${arg})
		message("argv" ${ARGV})
		message("arg es ${arg}")
		message("argb es${ARGV}")
	
		set(inner_arg ${arg} )
		message("innerarg ${inner_arg}")

		set(inner_arg ${ARGV} )
		message("innerarg ${inner_arg}")

		set(inner_arg "${arg}")
		message("innerarg ${inner_arg}")

		set(inner_arg "${arg}")
		message("innerarg ${inner_arg}")
	

	endfunction()


	function(eval_func code)
		random_file(fn "${cutil_temp_dir}/{{id}}.tmp")
		file(WRITE ${fn} "${code}")
		include(${fn})
		file(REMOVE ${fn})
	endfunction()


	macro(eval_macro code)
		random_file(fn "${cutil_temp_dir}/{{id}}.tmp")
		file(WRITE ${fn} "${code}")
		include(${fn})
		file(REMOVE ${fn})
	endmacro()

	function(call_func_func func)
		eval_func("${func}(${ARGN})")
	endfunction()

	function(call_func_macro func)
		eval_macro("${func}(\${ARGN})")

	endfunction()

	macro(call_macro_macro func)
		eval_macro("${func}(${ARGN})")

	endmacro()
	macro(call_macro_func func)
		eval_func("${func}(\${ARGN})")
	endmacro()

	set(str "\${ARGN}")
	inner("\${ARGN}")
	inner(\${ARGN})
	inner("${str}")
	inner(";")


	eval_macro("function(testfu) \n message(\"\${ARGN}\")\n endfunction()")
	testfu(a b c d e f g)
	eval("function(testfu) \n message(\"\${ARGN}\")\n endfunction()")
	testfu(a b c d e f g)
	eval_func("function(testfu) \n message(\"\${ARGN}\")\n set(result \"\${ARGN}\" PARENT_SCOPE)\n endfunction()")
	testfu(a b c d e f g)

	set(result)
	call_func_func(testfu 1 2 3 4)
	message("result ${result}")
	
	set(result)
	call_macro_macro(testfu 1 2 3 4)
	message("result ${result}")
	
	#call_macro_func(testfu 1 2 3 4)
endfunction()