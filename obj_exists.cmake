#returns true if object exists
function(obj_exists ref result)
	eval_truth(res EXISTS ${ref})
	return_value(${res})
endfunction()