function(list_any lst predicate)
	lambda(predicate "${predicate}")
	function_import("${predicate}" as predicate_function)
	set(ct 0)
	foreach(item ${lst})
		predicate_function(res "${item}")
		if(res)
			return(true)
		endif()
	endforeach()
	return(false)
endfunction()



