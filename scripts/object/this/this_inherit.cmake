#inherits from base (if base is an objct it will be set as the prototype of this)
# if base is a function / constructor then a base object will be constructed and set
# as the prototy of this
function(this_inherit base)
	set(ok)
	obj_exists(${base} ok)
	if(NOT ok)
		obj_new(base ${base})
		return()
	endif()	
	obj_setprototype(${this} ${base})
endfunction()