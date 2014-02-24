
# forgiving version of CAR.
# returns the first element of a list or a element filled with NOTFOUND if list is empty
# also sets the variable VARNAME-NOTFOUND if list is empty
# usage CAR(VARNAME  ${list})  
function(CAR)

  # rest of list
  macro(_CDR var junk)
    set(${var} ${ARGN})
  endmacro()
  #first element of list
  macro(_CAR var)
    SET(${var} ${ARGV1})
  endmacro()
  list(LENGTH ARGN out_length  )
  if(${out_length} LESS 1)
  	message(FATAL "invalid usage of CAR,  at least one argument expected")
  elseif(${out_length} LESS 2)
  	set(${ARGV0} NOTFOUND PARENT_SCOPE)
	set("${ARGV0}-NOTFOUND" 1 PARENT_SCOPE) 	
  elseif(${out_length} LESS 3)
  	set(${ARGV0} ${ARGV1} PARENT_SCOPE)
  else()
  	_CDR(rest ${ARGN})
  	_CAR(res ${rest})
  	set(${ARGV0} ${res} PARENT_SCOPE)
  endif()
endfunction()