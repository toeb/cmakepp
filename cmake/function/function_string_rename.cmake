
# injects code into  function (right after function is called) and returns result
function(function_string_rename result input_function new_name) 
	get_function_string(function_string "${input_function}")
	function_signature_regex(regex)

	get_function_lines(lines "${input_function}")
	foreach(line ${lines})
		string(REGEX MATCH "${regex}" found "${line}")
		if(found)
			string(REGEX REPLACE "${regex}"  "\\1(${new_name} \\3)" new_line "${line}")
			string_replace_first("${line}" "${new_line}" "${input_function}")
			ans(input_function)
			break()
		endif()
	endforeach()
	set("${result}" "${input_function}" PARENT_SCOPE)
endfunction()