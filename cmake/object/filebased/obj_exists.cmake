#returns true if object exists
function(obj_exists this result)
	#eval_truth(EXISTS ${this})
	#ans(res)
  ref_isvalid( ${this} )
  ans(res)
	return_value(${res})
endfunction()