

macro(push_back var val)
	get_property(lst GLOBAL PROPERTY ${var})
	list(APPEND lst ${val})
	set_property(GLOBAL PROPERTY ${var} ${lst})
	#debug_message("pushback ${lst}")
endmacro()


