## prints the specified variables names and their values in a single line
## e.g.
## set(varA 1)
## set(varB abc)
## print_vars(varA varB)
## output:
##  varA: '1' varB: 'abc'
  function(print_vars)
    set(args "${ARGN}")
    list_extract_flag(args --plain)
    ans(plain)
    set(__str)
    foreach(arg ${args})
      assign(____cur = ${arg})
      if(NOT plain)
        json("${____cur}")
        ans(____cur)
      else()
        set(____cur "'${____cur}'")
      endif()

      string_shorten("${____cur}" "300")
      ans(____cur)
      set(__str "${__str} ${arg}: ${____cur}")

    endforeach()
    message("${__str}")
  endfunction()