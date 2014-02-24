# declares a function on object called ${function}
# after call ${function} will contain a unique function id
# which can be used to define the function
# example:
# assume ${obj}  a object reference (see obj_create)
# obj_declarefunction(${obj} myfunc)
# function(${myfunc} ...)
# ...
# endfunction()
# ${obj} will now have a property called myfunc which contains
# the defined function
# if function is called before it is declared the programm will cause an error
# ${myfunc} contains a unique function id (see new_function)
# the function can be called by obj_callmember(${obj} "myfunc" ... )
function(obj_declarefunction object function)
	new_function(func)
	obj_setfunction(${object} "${function}" "${func}")
	set(${function} "${func}" PARENT_SCOPE)
endfunction()