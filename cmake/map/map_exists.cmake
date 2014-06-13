function(map_exists this )
	get_property(map_exists GLOBAL PROPERTY "${this}" SET)
  return(${map_exists})
endfunction()