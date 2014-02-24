function(obj_bind bound_function object func)

	new_function(wrapper)	
	save_function("${cutil_temp_dir}/${wrapper}" "macro(${wrapper})\n obj_bindcall(${object} ${func} \${ARGN}) \nendmacro()")
	include("${cutil_temp_dir}/${wrapper}")
	set(bound_function "${wrapper}" PARENT_SCOPE)
	file(REMOVE "${cutil_temp_dir}/${wrapper}")
endfunction()