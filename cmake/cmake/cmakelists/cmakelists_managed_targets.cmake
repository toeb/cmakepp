
  function(cmakelists_managed_targets cmakelists)
    cmakelists_targets("${cmakelists}")
    ans(targets)

    foreach(target ${targets})
      cmakelists_managed_target(${cmakelists} ${target})
    endforeach() 
    return_ref(targets)
  endfunction()
