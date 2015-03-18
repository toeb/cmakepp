
function(cmakelists_close cmakelists) 
    map_tryget(${cmakelists} path)
    ans(cmakelists_path)
    cmakelists_serialize("${cmakelists}")
    ans(content)
    fwrite("${cmakelists_path}" "${content}")
  endfunction()