


function(build_task_execute buildTask parameters)
    build_task_command_eval(${buildTask} ${parameters})
    ans(commands)

    foreach(command ${commands})
        build_task_command_execute(${command})
        ans(success)
        if(NOT success)
            message(FATAL_ERROR "failed to execute command '${command}'")
            return(false)
        endif()
        
    endforeach()
    return(true)
endfunction()   