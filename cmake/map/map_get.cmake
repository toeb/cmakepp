function(map_get this result key )
	set(property_ref "${this}.${key}")
	
  get_property(property_exists GLOBAL PROPERTY "${property_ref}" SET)
  if(NOT property_exists)
    message(FATAL_ERROR "map '${this}' does not have key '${key}'")    
  endif()

  get_property(property_val GLOBAL PROPERTY "${property_ref}")

	set(${result} "${property_val}" PARENT_SCOPE)
  return_ref(property_val)
endfunction()