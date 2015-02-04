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
      assign(____cur = ${arg})
      json_serialize("${____cur}")
      ans(____cur)
      string_shorten("${____cur}" "300")
      ans(____cur)
      set(__str "${__str} ${arg}: ${____cur}")

    endforeach()
    message("${__str}")
  endfunction()