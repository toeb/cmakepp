# returns all keys for the specified map
function(map_keys this)
	get_property(keys GLOBAL PROPERTY "${this}")
  return_ref(keys)
endfunction()
