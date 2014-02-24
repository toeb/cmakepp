
macro(peek_front var result)
	get_property(lst GLOBAL PROPERTY ${var})
	list(GET lst 0 ${result})
	debug_message("peeking frons ${result}")
endmacro()