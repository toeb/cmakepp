function(ref_get ref result )
	#local ref
	set(ref_value)
	get_property(ref_value GLOBAL PROPERTY "${ref}")
	set(${result} ${ref_value} PARENT_SCOPE)
	#message("getting Ref  '${result}'' '${${result}}'' ${res}")
endfunction()