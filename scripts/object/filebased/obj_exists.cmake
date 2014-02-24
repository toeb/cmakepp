#returns true if object exists
function(obj_exists this result)
	eval_truth(res EXISTS ${this})
	return_value(${res})
endfunction()