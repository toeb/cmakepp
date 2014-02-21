
function(obj_import result object)
	
	if(NOT EXISTS "${object}")
		message(FATAL_ERROR "could not find object ${object}")
	endif()
	obj_construct(${object})
	return_value("${object}")	
endfunction()