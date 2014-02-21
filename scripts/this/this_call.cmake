
macro(this_call)
	this_check()
	obj_call(${this} ${ARGN})
endmacro()