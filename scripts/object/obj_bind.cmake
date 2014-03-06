# defines a unique function (${bound_function} is set to its name) which calls func
# bound to ${object} (giving ${func} access to ${this})
function(obj_bind bound_function object func)
	
	is_function_string(is_string_func "${func}")
	if(is_string_func)
		ref_setnew(func "${func}")
	endif()
	new_function(wrapper)	
	save_function("${cutil_temp_dir}/${wrapper}" "macro(${wrapper})\n obj_pushcontext(${object}) \n import_function(\"${func}\" as bound_function REDEFINE) \n bound_function(\${ARGN}) \nobj_popcontext() \nendmacro()")
	include("${cutil_temp_dir}/${wrapper}")
	set(${bound_function} "${wrapper}" PARENT_SCOPE)
	file(REMOVE "${cutil_temp_dir}/${wrapper}")
endfunction()