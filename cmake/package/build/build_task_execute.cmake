



function(build_task_execute buildTask buildParameters)    
    map_tryget(${buildTask} commands)    
    ans(commands)

    map_tryget(${buildParameters} build_dir)
    ans(build_dir)
    log("trying to build in '${build_dir}'" --function "build_task_execute")

    pushd("${build_dir}" --create)
    ans(build_dir)

    foreach(command ${commands})
        build_task_command_execute(${command})
        ans(success)
        if(NOT success)
            error("failed to execute command")
            popd()
            return(false)
        endif()

    endforeach()
    popd()

    return(true)

endfunction()