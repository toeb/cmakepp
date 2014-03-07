macro(return_result)
	set_property(GLOBAL PROPERTY __result ${ARGN})
	return()
endmacro()