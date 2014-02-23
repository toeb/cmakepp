
macro(this_call)
	this_check()
	obj_callmember(${this} ${ARGN})
endmacro()