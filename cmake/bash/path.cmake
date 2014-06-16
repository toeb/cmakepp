
  # returns the fully qualified path name for path
  # if path is a fully qualified name it returns path
  # else path is interpreted as the relative path 
  function(path path)

    get_filename_component(realpath "${path}" REALPATH)
    if("_${path}" MATCHES "^_[a-zA-Z]:\\/")
      # windows absolute path
      #message("wpath ${path} -> ${realpath}")
      return_ref(realpath)
    endif()
    if("_${path}" MATCHES "^_\\/")
      # unix absolute path
     # message("upath ${realpath}")
      
      return_ref(realpath)
    endif()

    # relative path
    pwd()
    ans(pwd)
    set(path "${pwd}/${path}")
    get_filename_component(realpath "${path}" REALPATH)
    
     # message("rpath ${realpath}")
    return_ref(realpath)
  endfunction()
