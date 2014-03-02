# appends all variable args to the specified varaible "global_${varname}"
function(global_append varname)
	set_property(GLOBAL APPEND PROPERTY "global_${varname}" "${ARGN}")
	get_property(val GLOBAL PROPERTY "global_${varname}")
	set(${varname} "${val}" PARENT_SCOPE)
endfunction()