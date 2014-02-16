function(obj_setprototype ref ref_proto)
	obj_setownproperty(${ref} __proto__ ${ref_proto})
endfunction()