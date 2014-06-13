
# injects code into  function (right after function is called) and returns result
function(inject_function result input_function) 
	set(options )
	set(oneValueArgs RENAME BEFORE_FUNCTION AFTER_FUNCTION ON_CALL)
	set(multiValueArgs)
	set(prefix)
	cmake_parse_arguments("${prefix}" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
	
	#todo:  find functions with signatures contains carriage returns and tabs
	# fixed: todo: allow function names that start with f u n c t i on

	get_function_string(function_string "${input_function}")
	function_signature_regex(regex)

	get_function_lines(lines "${input_function}")
	foreach(line ${lines})
		string(REGEX MATCH "${regex}" found "${line}")
		if(found)
			#rename function if a rename argument is specified
			if(_RENAME)	
				#string(REGEX REPLACE "${regex}"  "\\2" function_name "${line}")
				string(REGEX REPLACE "${regex}"  "\\1(${_RENAME} \\3)" new_line "${line}")

			else()
				set(new_line "${line}")
			endif()


			string_replace_first( "${line}" "#  BEFORE_FUNCTION injection \n ${_BEFORE_FUNCTION} \n # endof injection \n ${new_line} \n #ON_CALL injection \n ${_ON_CALL} \n #endof injection \n" "${input_function}")
			ans(input_function)
			break()
		endif()
	endforeach()

	set(${result} "${input_function} \n #  AFTER_FUNCTION  injection \n ${_AFTER_FUNCTION} \n #endof injection" PARENT_SCOPE)




endfunction()