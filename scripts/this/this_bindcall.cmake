macro(this_bindcall)
	this_check()
	obj_bindcall(${this} ${ARGN})
endmacro()