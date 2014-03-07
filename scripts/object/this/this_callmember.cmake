
macro(this_callmember)
	this_check()
	obj_callmember(${this} ${ARGN})
endmacro()