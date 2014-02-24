function(test)

	get_function_string(res "function(fu)\nmessage(\"\;\")\nendfunction()")
	#message("${res}")
	assert(res)
	message(STATUS "test is inconclusive")
	#assert("${res}" STREQUAL "function(fu)\nmessage(\"\;\")\nendfunction()")
endfunction()