function(obj_callref this)
	is_member( res ${this})
	if(NOT res)
		message(FATAL_ERROR "${this} is not a member reference")
	endif()
	# get object and member from ref
	#get_filename_component(member ${this} NAME_WE)
	#get_filename_component(object ${this} DIRECTORY)
	# call memberfunction
	obj_getrefvalue(${this} func)

	obj_pushcontext(${this})
	import_function("${func}" as bound_function REDEFINE)
	bound_function()
	obj_popcontext()
	#obj_bindcall(${object} "${func}" ${ARGN})
endfunction()