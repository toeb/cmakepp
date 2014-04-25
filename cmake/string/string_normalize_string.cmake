# replaces all non alphanumerical characters in a string with an underscore
function(string_normalize input)
	string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" res "${input}")
	return_ref(res)
endfunction()