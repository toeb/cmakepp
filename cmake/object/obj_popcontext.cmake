
macro(obj_popcontext)
	pop_front("callstack" current_context)
	# saving context is not cool because using obj_set() 
	# might create a key in the object which is then overwritten with NOTFOUND
	# because it is not loaded in the current context..
	#obj_savecontext(${current_context})
	peek_front("callstack" current_context)
	if(current_context)
		obj_loadcontext(${current_context})
	endif()
	set(this ${current_context})
endmacro()