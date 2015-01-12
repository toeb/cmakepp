
  ## returns the list of indices for the specified range
  ## length may be -1 which causes a failure if the $ or n are used in the range
  ## if range is a valid length (>-1) then only valid indices are returned or a 
  ## failure occurs
  ## a length of 0 always returns no indices
  function(range_indices length)

    if("${length}" EQUAL 0)
      return()
    endif()
    if("${length}" LESS 0)
      set(length 0)
    endif()
    range_instanciate("${length}" ${ARGN})
    ans(range)
    set(indices)

    foreach(partial ${range})
      string(REPLACE ":" ";" partial "${partial}")
      list(GET partial 0 1 2 partial_range)
      foreach(i RANGE ${partial_range})
        list(APPEND indices ${i})
      endforeach() 
      list(GET partial 3 begin_inclusivity)
      list(GET partial 4 end_inclusivity)
      if(NOT end_inclusivity)
        list_pop_back(indices)
      endif()
      if(NOT begin_inclusivity)
        list_pop_front(indices)
      endif()
    endforeach()
   # message("indices for len '${length}' (range ${range}): '${indices}'")
    return_ref(indices)
  endfunction()
