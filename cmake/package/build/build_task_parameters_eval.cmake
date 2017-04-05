
 ## evaluates the build task parameters and returns a new map of evaluated params
 function(build_task_parameters_eval parameters)
    ## evaluate all template parameters
    map_template_evaluate_scoped(${parameters} ${parameters})
    ans(parameters)

    ## create a checksum that evaluates uniquely identifies this parametermap
    checksum_object(${parameters})
    ans(checksum)
    map_set(${parameters} task_id "${checksum}")
    return(${parameters})
 endfunction()