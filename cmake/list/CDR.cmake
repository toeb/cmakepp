

# forgiving version of CDR.
# returns the elements of the list without the first element
# if the rest of the list is empty it is set to NOTFOUND
# also sets VARNAME-NOTFOUND if rest of list is empty  
function(CDR)

  # rest of list
  macro(_CDR var junk)
    set(${var} ${ARGN})
  endmacro()
  list(LENGTH ARGN out_length  )
  if(${out_length} LESS 1)
  	message(FATAL "invalid usage of CDR,  at least one argument expected")
  elseif(${out_length} LESS 3)
  	set(${ARGV0} NOTFOUND PARENT_SCOPE)
	set("${ARGV0}-NOTFOUND" 1 PARENT_SCOPE) 	
  else()
  	_CDR(rest ${ARGN})
  	_CDR(rest ${rest})
  	set(${ARGV0} ${rest} PARENT_SCOPE)
  endif()
endfunction()
