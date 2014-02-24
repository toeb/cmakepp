# returns the source of a function renaming it to the specified new name
# 
function(rename_function result new_name input_function)
	get_function_string(function_string "${input_function}")
	get_function_lines(lines "${function_string}")
	function_signature_regex(regex)

	foreach(line ${lines})
		string(REGEX MATCH "${regex}" found "${line}")

		if(found)
			string(REGEX REPLACE "${regex}"  "\\2" function_name "${line}")
			string(REPLACE "${function_name}" "${new_name}" new_line "${line}"  )
			message("${function_name}")
			string(REPLACE "${line}" "${new_line}"  input_function "${input_function}")
			break()
		endif()
	endforeach()

	set(${result} ${input_function} PARENT_SCOPE)
endfunction()