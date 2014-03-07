macro(obj_callobject this)
	obj_callmember(${this} __call__ ${ARGN})
endmacro()