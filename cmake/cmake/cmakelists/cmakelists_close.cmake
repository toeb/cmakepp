

  function(cmakelists_close cmakelists) 
    map_tryget(${cmakelists} begin)
    ans(begin)
    cmake_token_range_serialize("${begin}")
    ans(content)
    map_tryget(${cmakelists} path)
    ans(cmakelists_path)
    fwrite("${cmakelists_path}" "${content}")
  endfunction()