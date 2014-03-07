
# reads a functions and stores the result in a file
function(load_function result file_name)
	
	file(READ ${file_name} func)
	
	set(${result} ${func} PARENT_SCOPE)
endfunction()