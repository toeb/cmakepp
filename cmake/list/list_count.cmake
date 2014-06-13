
function(list_count lst predicate)
	lambda(predicate "${predicate}")
	function_import("${predicate}" as predicate_function)
	set(ct 0)
	foreach(item ${lst})
		predicate_function(res "${item}")
		if(res)
			math(EXPR ct "${ct} + 1")	
		endif()
	endforeach()
	return("${ct}")
endfunction()

