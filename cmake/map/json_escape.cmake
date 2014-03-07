# function to escape json
function(json_escape result value)
	string(REGEX REPLACE "\\\\" "\\\\\\\\" value "${value}")
	string(REGEX REPLACE "\\\"" "\\\\\"" value "${value}")
	string(REGEX REPLACE "\n" "\\\\n" value "${value}")
	string(REGEX REPLACE "\r" "\\\\r" value "${value}")
	string(REGEX REPLACE "\t" "\\\\t" value "${value}")
	string(REGEX REPLACE "\\$" "\\\\$" value "${value}")	
	string(REGEX REPLACE ";" "\\\\\\\\;" value "${value}")

	#string(REGEX REPLACE "\;" "" value "${value}")

	#string(REPLACE "\\" "\\\\" value "${value}")
	#string(REPLACE "\n" "\\\\n" value "${value}")
	##string(REPLACE "\r" "\\\\r" value "${value}")
	#string(REPLACE "\t" "\\\\t" value "${value}")
	#string(REPLACE "$" "\\$" value "${value}")
	#string(REPLACE ";" "\\\\;" value "${value}")
	#string(REPLACE "\"" "'" value "${value}")

	set(${result} "${value}" PARENT_SCOPE)
endfunction()