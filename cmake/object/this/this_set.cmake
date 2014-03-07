
macro(this_set member_name)
	this_check()
	obj_set(${this} ${member_name} "${ARGN}")
	#debug_message("setting ${member_name} to ${ARGN}")
	# todo.  only one of the two should be used....... this causes problems depending on which in which context this is called
	set(${member_name} "${ARGN}" PARENT_SCOPE)
	set(${member_name} "${ARGN}")

endmacro()