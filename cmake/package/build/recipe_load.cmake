
  parameter_definition(recipe_load
    [--target-dir{"the build task to execute"}=>target_dir:<string>]
    "#loads a recipe"
    )
  function(recipe_load recipe)
    arguments_extract_defined_values(0 ${ARGC} recipe_load)    


    if(NOT target_dir)
      path(.)
      ans(target_dir)
    endif()




    map_clone_deep("${recipe}")
    ans(recipe)



    map_tryget(${recipe} parameters)
    ans(parameters)


    ## get package
    map_tryget(${recipe} uri)
    ans(uri)
    default_package_source()
    ans(source)
    package_source_push_path(${source} "${uri}" => "${target_dir}/source")
    ans(packageHandle)

    if(NOT packageHandle)
      error("could not load package '${uri}'")
      return()
    endif()

    map_tryget(${packageHandle} content_dir)
    ans(content_dir)


    map_tryget(${recipe} build_descriptor)
    ans(build_descriptor)
    map_set(${packageHandle} build_descriptor ${build_descriptor})
    
    map_tryget(${recipe} binary_descriptor)
    ans(binary_descriptor)
    map_set(${packageHandle} binary_descriptor ${binary_descriptor})


    map_permutate(${parameters})
    ans(parameters)

    ## foreach?!
    list_peek_front(parameters)
    ans(param)  
    map_set(${param} config release)
    map_set(${param} "build_dir" "${target_dir}/build")
    map_set(${param} "install_dir" "${target_dir}/stage")
    map_set(${param} "content_dir" "${content_dir}")


    map_template_evaluate_scoped(${param} ${build_descriptor})
    ans(evaluated_build_descriptor)

    map_conditional_evaluate("" ${evaluated_build_descriptor})
    ans(evaluated_build_descriptor)

    map_template_evaluate_scoped("${param}" ${binary_descriptor})
    ans(evaluated_binary_descriptor)

    map_conditional_evaluate("" ${evaluated_binary_descriptor})
    ans(evaluated_binary_descriptor)

    build_task_execute("${evaluated_build_descriptor}" ${param})

    json_write("${target_dir}/recipe.json" ${recipe})
    json_write("${target_dir}/parameters.json" ${param})
    json_write("${target_dir}/build.json" ${evaluated_build_descriptor})
    json_write("${target_dir}/binary.json" ${evaluated_binary_descriptor})
    json_write("${target_dir}/package.json" "${packageHandle}")

    map_append(${packageHandle} builds "${evaluated_build_descriptor}")
    map_append(${packageHandle} binaries "${evaluated_binary_descriptor}")


    return_ref(packageHandle)
  endfunction()  