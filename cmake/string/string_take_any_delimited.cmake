## takes a string which is delimited by any of the specified
## delimiters 
## string_take_any_delimited(<string&> <delimiters:<delimiter...>>)
  function(string_take_any_delimited str_ref)
    foreach(delimiter ${ARGN})
      string(LENGTH "${${str_ref}}" l1)
      string_take_delimited(${str_ref} "${delimiter}")
      ans(match)
      string(LENGTH "${${str_ref}}" l2)
      if(NOT "${l1}" EQUAL "${l2}")
        set("${str_ref}" "${${str_ref}}" PARENT_SCOPE)
        return_ref(match)
      endif()

    endforeach()
    return()
  endfunction()
