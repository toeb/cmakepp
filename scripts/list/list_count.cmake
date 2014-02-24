
function(list_count result lst predicate)
	lambda(predicate "${predicate}")
	import_function("${predicate}" as predicate_function)
	set(ct 0)
	foreach(item ${lst})
		predicate_function(res "${item}")
		if(res)
			math(EXPR ct "${ct} + 1")	
		endif()
	endforeach()
	return_value("${ct}")
endfunction()

