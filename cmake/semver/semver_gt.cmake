
  function(semver_gt  a b)
    semver_compare(res "${a}" "${b}") 
    ans(res)
    if(${res} LESS 0)
      return(true)
    endif()
    return(false)
  endfunction()