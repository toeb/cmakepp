
## evalutes the command template of specified build task
## using the parameter set supplied
function(build_task_command_eval buildTask parameters)
    map_tryget(${buildTask} command_template)
    ans(template)

    template_run_scoped("${parameters}" "${template}")
    ans(evaluatedCommand)

    return_ref(evaluatedCommand)
endfunction()