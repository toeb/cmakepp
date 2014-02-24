
macro(list_replace_at lst i new_value)
	list(INSERT ${lst} ${i} ${new_value})	
	math(EXPR i_plusone "${i} + 1" )
	list(REMOVE_AT ${lst} ${i_plusone})
endmacro()
