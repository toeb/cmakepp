function(global_get varname)
	get_property(val GLOBAL PROPERTY "global_${varname}")
	set(${varname} "${val}" PARENT_SCOPE)
endfunction()