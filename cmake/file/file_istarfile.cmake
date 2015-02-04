## returns true if the specified file is a tar archive 
function(file_istarfile file)
	path_qualify(file)
	if(NOT EXISTS "${file}")
		return(false)
	endif()
	if(IS_DIRECTORY "${file}")
		return(false)
	endif()
	tar(ztvf "${file}" --return-code)
	ans(res)
	if(NOT res EQUAL 0)
		return(false)
	endif()

	return(true)
	
endfunction()




