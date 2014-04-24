# returns true if ref is member of an object
function(is_member result ref)
	map_navigate(res "${ref}")
	return_value(${res})
	
endfunction()