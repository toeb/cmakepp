
## evalutes the command template of specified build task
## using the parameter set supplied
function(build_task_command_eval buildTask parameters)
    map_tryget(${buildTask} commands)
    ans(command_template)

    template_run_scoped("${parameters}" "${command_template}")
    ans(evaluatedCommand)

    return_ref(evaluatedCommand)
endfunction()