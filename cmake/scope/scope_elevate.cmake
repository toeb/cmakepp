
macro(scope_elevate)
	get_cmake_property(vars VARIABLES)
	foreach(var ${vars})
		set(${var} "${${var}}" PARENT_SCOPE)
	endforeach()
endmacro()