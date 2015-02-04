
  ## glob_paths(<unqualified glob path>) -> <qualified glob path.>
  ##
  ## 
  function(glob_path glob)
    string_take_regex(glob "[^\\*\\[{]+")
    ans(path)
    path_qualify(path)

    if(glob)
      set(path "${path}/${glob}")
    endif()
    return_ref(path)
 endfunction()
