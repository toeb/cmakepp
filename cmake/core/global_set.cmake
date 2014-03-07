# sets a global property called global_${varname} to all other arguments passed
# also sets the variable in the current scope 
function(global_set varname)
	set_property(GLOBAL PROPERTY "global_${varname}" "${ARGN}")
	set(${varname} ${${varname}} PARENT_SCOPE)
endfunction()