  function(cmakelists_new source)
    path("${ARGN}")
    ans(path)

    map_new()
    ans(cmakelists)

    cmake_token_range("${source}")

    ans_extract(begin end)    
    map_set(${cmakelists} begin ${begin})
    map_set(${cmakelists} end ${end} )
    map_set(${cmakelists} range ${begin} ${end})
    map_set(${cmakelists} path "${cmakelists_path}")

    return_ref(cmakelists)
  endfunction()
