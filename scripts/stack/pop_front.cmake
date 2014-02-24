
macro(pop_front  var result)
	get_property(lst GLOBAL PROPERTY ${var})
	list(GET lst 0 ${result})
	list(REMOVE_AT lst 0)
	set_property(GLOBAL PROPERTY ${var} ${lst})
	debug_message("popfront ${lst}")
endmacro()