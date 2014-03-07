
function(list_any result lst predicate)

	lambda(predicate "${predicate}")
	import_function("${predicate}" as predicate_function)
	set(ct 0)
	foreach(item ${lst})
		predicate_function(res "${item}")
		if(res)
			return_value(true)
		endif()
	endforeach()
	return_value(false)
endfunction()



