message("now!!")

macro(this_get member_name)
	this_check()
	obj_import_member(${this} ${member_name})
endmacro()