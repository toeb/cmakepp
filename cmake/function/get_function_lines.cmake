# returns the function content in a list of lines.
# cmake does nto support a list containing a strings which in return contain semicolon
# the workaround is that all semicolons in the source are replaced by a separate line containsing the string ![[[SEMICOLON]]]
# so the number of lines a function has is the number of lines minus the number of lines containsing only ![[[SEMICOLON]]]
function(get_function_lines result func)
	get_function_string(function_string "${func}")
	string(REPLACE ";" "![[[SEMICOLON]]]"  function_string "${function_string}")
	string(REPLACE "\n" ";" lines "${function_string}")
	set(res)
	foreach(line ${lines})
		string(FIND "${line}" "![[[SEMICOLON]]]" hasSemicolon)
		if(${hasSemicolon} GREATER "-1")
			string(SUBSTRING "${line}" 0 ${hasSemicolon} part1)
			math(EXPR hasSemicolon "${hasSemicolon} + 16")
			string(SUBSTRING "${line}" ${hasSemicolon} "-1" part2)

			#string(REPLACE "" "${sc}" line "${line}")
			set(res ${res} "${part1}" "![[[SEMICOLON]]]" "${part2}")
		else()
			set(res ${res} ${line})
		endif()
	endforeach()

	set(${result} ${res} PARENT_SCOPE)
endfunction()