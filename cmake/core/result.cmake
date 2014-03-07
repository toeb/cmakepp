macro(result var_name)
	get_property(${var_name} GLOBAL PROPERTY __result)
endmacro()