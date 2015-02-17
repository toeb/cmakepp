
  function(map_set_if_missing map prop)
    map_has("${map}" "${prop}")
    if(__ans)
      return(false)
    endif()
    map_set("${map}" "${prop}")
    return(true)
  endfunction()
