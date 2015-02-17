  ## compares the specified files
  ## returning true if their content is the same else false
  function(file_equals lhs rhs)
    path("${lhs}")
    ans(lhs)

    path("${rhs}")
    ans(rhs)

    cmake(-E compare_files "${lhs}" "${rhs}" --exit-code)
    ans(return_code)
    
    if("${return_code}" STREQUAL "0")
      return(true)
    else()
      return(false)
    endif()

  endfunction()
