macro(this_get member_name)
	this_check()
	obj_get(${this} ${${member_name}} ${member_name})
endmacro()