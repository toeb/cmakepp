# causes a FATAL_ERROR if ${this} is not a valid object reference
function(obj_nullcheck this)
	is_object(is_ok ${this})
	if(NOT is_ok)
  		message(FATAL_ERROR "null reference '${this}'")
	endif()
endfunction()