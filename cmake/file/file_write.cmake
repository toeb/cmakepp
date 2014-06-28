
  # writes the specified content to the specified path
  function(file_write path content)
    path("${path}")
    ans(path)
    if(IS_DIRECTORY "${path}")
      message(WARNING "trying to write to path '${path}' which is a directory")
      return(false)
    endif()
    file(WRITE "${path}" "${content}")
    return(true)
  endfunction()