
function(obj_extend result parent)
	obj_nullcheck(${parent})
	obj_create(ref ${ARGN})
	obj_setprototype(${ref} ${parent})
	return_value(${ref})
endfunction()
