


  ## glob(<glob expression...> [--relative] [--recurse]) -> <path...>
  ##
  ## 
 function(glob)
    set(args ${ARGN})
    list_extract_flag(args --relative)
    ans(relative)
    
    list_extract_flag(args --recurse)
    ans(recurse)


    glob_paths(${args})
    ans(globs)

    pwd()
    ans(pwd)
    if(recurse)
      set(glob_command GLOB_RECURSE)
    else()
      set(glob_command GLOB)
    endif()

    if(relative)
      set(relative RELATIVE "${pwd}")
    else()
      set(relative)
    endif()

    set(paths)
    if(globs)
      file(${glob_command} paths ${relative} ${globs})
      list_remove_duplicates(paths)
    endif()
    return_ref(paths)
 endfunction()
