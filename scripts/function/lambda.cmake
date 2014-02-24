

#converts a lambda expression into a valid function string
function(lambda result expression)
	string(FIND "${expression}" "function" isfunc)
	
	if("${isfunc}" GREATER "-1")
		set(${result} "${expression}" PARENT_SCOPE)
		return()
	endif()
	replace_first(expression "(" "function(lambda_func result "  "${expression}")
	replace_first(expression ")" ")\n" "${expression}")
	set(${result} "${expression}\nendfunction()" PARENT_SCOPE)
endfunction()
