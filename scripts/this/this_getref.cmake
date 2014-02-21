

# imports a ref into current scope
# expects a variable 'this' to evaluate to an object
# reference
macro(this_getref member_name)
	this_check()
	obj_import_ref(${this} ${ref_name})
endmacro()
