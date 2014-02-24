


function(map_keys this result)
	get_property(keys GLOBAL PROPERTY "${this}")
	set(${result} ${keys} PARENT_SCOPE)
endfunction()
