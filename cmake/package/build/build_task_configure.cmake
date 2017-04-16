

  parameter_definition(build_task_configure
    <--build-task{"the build task to execute"}=>build_task:<map>>
    <--package-handle{"the package to build with specified task"}=>packageHandle:<map>>
    [--install-dir{"the <~path> where to install the result of the build"}=>install_dir:<string>="stage/@package_descriptor.id/@package_descriptor.version"]
    [--build-dir{"the <~path> where to build the result"}=>build_dir:<string>=build]
    [--content-dir{"the readonly <~path> where the sources lie"}=>content_dir:<string>="@package_handle.content_dir"]
    [--verbose{"extensive log info"}]
    "#configureds build tasks"
    )
  function(build_task_configure)
    arguments_extract_defined_value_map(0 ${ARGC} build_task_configure)    
    
    ans_extract(args)
    ans(rest)

    ## import parameter scope
    map_import_properties_all(${args})


    ## create a clone as to not modify input args
    map_tryget(${build_task} parameters)
    ans(parameters)
    map_clone_deep(${parameters})
    ans(parameters)
    ##right here dude!
    message("buildtask")
    json_print(${build_task})
    map_tryget(${build_task} output)
    ans(output)
    map_clone(${output})
    ans(output)


    ## setup environment
    assign(parameters.package_descriptor = args.packageHandle.package_descriptor)
    assign(parameters.content_dir = content_dir)    
    assign(parameters.install_dir = install_dir)    
    assign(parameters.build_dir = build_dir)    
    assign(parameters.package_handle = args.packageHandle)
 
    ## evaluated parameters 
    build_task_parameters_eval(${parameters})
    ans(parameters)
    
    map_template_evaulate_scoped("${output}" "${parameters}")
    ans(output)


    json_print(${output})


    if(verbose)
        map_tryget(${build_task} commands)
        ans(command_template)

        template_run_scoped(${parameters} "${command_template}")
        ans(command)

        path(".")
        ans(currentPath)

        message(INFO PUSH_AFTER "executing build task")
        message(INFO "pwd: '${currentPath}'")
        foreach(cmd ${command})
            path_replace_relative("${currentPath}" ${cmd})
            ans(cmd)
            message(INFO ">>> ${cmd}")
        endforeach()
        message(POP)
    endif()


    return(${parameters})
  endfunction()
