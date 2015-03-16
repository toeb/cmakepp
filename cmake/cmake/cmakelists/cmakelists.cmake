
function(cmakelists)

    set(args ${ARGN})
    list_pop_front(args)
    ans(cmd)


    cmakelists_open("")
    ans(cmakelists)
    map_new()
    ans(commands)
    map_set(${commands} add_target cmakelists_add_target)
    map_set(${commands} source cmakelists_target_add_source_files)
    map_set(${commands} targets cmakelists_managed_targets)

    
    map_tryget("${commands}" "${cmd}")
    ans(command)
    call2("${command}" ${cmakelists} ${args})
    ans(res)

    cmakelists_close(${cmakelists})
    
    return_ref(res)
endfunction()
