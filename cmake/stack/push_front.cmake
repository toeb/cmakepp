
macro(push_front var val)
	get_property(lst GLOBAL PROPERTY ${var})
	list(INSERT lst 0 "${val}")
	set_property(GLOBAL PROPERTY ${var} ${lst})
	debug_message("push_front ${lst}")
endmacro()
