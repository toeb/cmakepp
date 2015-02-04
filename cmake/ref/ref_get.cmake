function(ref_get ref )
	get_property(ref_value GLOBAL PROPERTY "${ref}")
  return_ref(ref_value)
endfunction()

# optimized version
macro(ref_get ref)
  get_property(__ans GLOBAL PROPERTY "${ref}")
endmacro()