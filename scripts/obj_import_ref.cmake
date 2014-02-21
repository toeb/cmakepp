
function(obj_import_ref this ref_name)
	obj_getref(${this} ref ${ref_name})
	set(${ref_name} ${ref} PARENT_SCOPE)
endfunction()