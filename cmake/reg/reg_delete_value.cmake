

  ## removes the specified value from the windows registry
  function(reg_delete_value key valueName)
    string(REPLACE / \\ key "${key}")
    reg(delete "${key}" /v "${valueName}" /f --return-code)
    ans(error)
    if(error)
      return(false)
    else()
      return(true)
    endif()
  endfunction()
