
macro(this_set member_name)
	this_check()
	obj_export_member(${this} ${member_name})
endmacro()