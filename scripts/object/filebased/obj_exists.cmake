#returns true if object exists
function(obj_exists this result)
	#eval_truth(res EXISTS ${this})
	ref_isvalid( ${this} res)
	return_value(${res})
endfunction()