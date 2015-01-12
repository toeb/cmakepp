## prints the specified variables names and their values in a single line
## e.g.
## set(varA 1)
## set(varB abc)
## print_vars(varA varB)
## output:
##  varA: '1' varB: 'abc'
  function(print_vars)
    set(__str)
    foreach(arg ${ARGN})
      set(__str "${__str} ${arg}: '${${arg}}'")
    endforeach()
    message("${__str}")
  endfunction()