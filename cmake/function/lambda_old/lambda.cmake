

#converts a lambda expression into a valid function string
function(lambda result expression)
	
	string(FIND "${expression}" "function" isfunc)
	
	if("${isfunc}" GREATER "-1")
		set(${result} "${expression}" PARENT_SCOPE)
		return()
	endif()
	string_replace_first("(" "function(lambda_func result "  "${expression}")
  ans(expression)
	string_replace_first(")" ")\n" "${expression}")
  ans(expression)
	set(${result} "${expression}\nendfunction()" PARENT_SCOPE)
endfunction()
