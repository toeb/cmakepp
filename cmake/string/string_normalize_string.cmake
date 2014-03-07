function(string_normalize_string result input)
	
	string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" res "${input}")
	return_value(${res})	

endfunction()