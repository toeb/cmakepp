  parameter_definition(build_task_execute
    <--build-task{"the build task to execute"}=>buildTask:<map>>
    <--package-handle{"the package to build with specified task"}=>packageHandle:<map>>
    [--install-dir{"the <~path> where to install the result of the build"}=>install_dir:<path>="stage/@packageHandle.package_descriptor.id/@packageHandle.package_descriptor.version"]
    [--build-dir{"the <~path> where to build the result"}=>build_dir:<path>=build]
    [--content-dir{"the readonly <~path> where the sources lie"}=>content_dir:<path>="@package_handle.content_dir"]
    "#executes a build task, "
    )
  function(build_task_execute)
    arguments_extract_defined_value_map(0 ${ARGC} build_task_execute)    
    ans_extract(config)
    ans(args)

    map_tryget(${config} buildTask)
    ans(buildTask)

    map_tryget(${buildTask} command)
    ans(command)

    map_tryget(${buildTask} command_template)
    ans(template)

    map_tryget(${buildTask} parameters)
    ans(parameters)

    map_clone_deep(${parameters})
    ans(parameters)

    map_tryget(${config} packageHandle)
    ans(packageHandle)
    map_set(${parameters} package_handle ${packageHandle})


    map_tryget(${config} content_dir)
    ans(content_dir)
    print_vars(content_dir)
    template_run_scoped(${parameters} "${content_dir}")
    ans(content_dir)

    print_vars(content_dir)


    map_set(${parameters} content_dir ${content_dir})

    template_run_scoped(${parameters} "${build_dir}")
    ans(build_dir)
    map_set(${parameters} build_dir "${build_dir}")

    template_run_scoped(${parameters} "${install_dir}")
    ans(install_dir)
    map_set(${parameters} install_dir "${install_dir}")


    template_run_scoped(${parameters} "${template}")
    ans(command)

    json_print(${parameters})

    # pushd("${build_dir}" --create)
    # foreach(cmd ${command})
    #   message(INFO "executing '${build_dir}> ${cmd}' ...")
    #   eval("execute(${cmd}  --exit-code)")
    #   ans(exitCode)
    #   if(exitCode)
    #     # got error        
    #     message(FATAL FORMAT "failed to build {ph.package_descriptor.id}@{ph.package_descriptor.version} while executing command ${cmd}")
    #   endif()      
    #   message(INFO "... done with '${cmd}'...")

    # endforeach()
    # popd()
    ## execute as shell?

    ## exeute cmake commands?

    ## what environment will i provide?

  endfunction()
