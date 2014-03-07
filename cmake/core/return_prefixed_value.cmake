
macro(return_prefixed_value key value)
	set("${result}_${key}" ${value} PARENT_SCOPE)
endmacro()
