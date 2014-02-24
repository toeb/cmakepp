	#bind func to object and imports the function as targetname
	function(obj_bindimport object func targetname)
		obj_bind(res ${object} ${func})
		import_function("${res}" as ${targetname})
	endfunction()