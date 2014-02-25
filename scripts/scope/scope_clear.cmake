# deletes all variables from current scope
# except some CMAKE vars and vars defined by cmake -D
# cmake vars not cleared:
#  CMAKE_COMMAND, CMAKE_CPACK_COMMAND, CMAKE_CTEST_COMMAND, CMAKE_EDIT_COMMAND, CMAKE_ROOT
macro(scope_clear)
	get_cmake_property(vars VARIABLES)
	foreach(var ${vars})
		#message("clearing ${var}")
		set(${var})
	endforeach()
	set(vars)
	set(var)
endmacro()