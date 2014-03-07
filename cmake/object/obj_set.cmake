# obj_set is a shorthand for writing a property
# if the property named key does not exist it will be created
function(obj_set this key)
	obj_setownproperty(${this} "${key}" "${ARGN}")
endfunction()