
  parameter_definition(recipe_load
    [--target-dir{"the directory where to load the recipe to"}=>target_dir:<string>]
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


    log("pulling package '${uri}'...")
    package_source_push_path(${source} "${uri}" => "${target_dir}/source")
    ans(packageHandle)
    log("...done pulling package '${uri}'")

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
    map_tryget(${param} install_dir)
    map_set(${param} "content_dir" "${content_dir}")


    map_template_evaluate_scoped(${param} ${build_descriptor})
    ans(evaluated_build_descriptor)

    map_conditional_evaluate("" ${evaluated_build_descriptor})
    ans(evaluated_build_descriptor)

    map_template_evaluate_scoped("${param}" ${binary_descriptor})
    ans(evaluated_binary_descriptor)

    map_conditional_evaluate("" ${evaluated_binary_descriptor})
    ans(evaluated_binary_descriptor)

    log("executing build task...")
    build_task_execute("${evaluated_build_descriptor}" ${param})
    ans(success)
    if(NOT success)
        error("...failed to execute build task")
        return()
    endif()

    log("...done executing build task.")

    checksum_dir("${install_dir}")
    ans(install_checksum)



    map_set(${evaluated_binary_descriptor} checksum_files "${install_checksum}")


    map_append(${packageHandle} builds "${evaluated_build_descriptor}")
    map_append(${packageHandle} binaries "${evaluated_binary_descriptor}")



    map_dfs_references_once(${packageHandle})
    ans(references)
    map_keys(${references})
    ans(references)
    foreach(reference ${references})
        map_keys(${reference})
        ans(keys)
        foreach(key ${keys})
            map_tryget(${reference} "${key}")
            ans(value)
            path_replace_relative("${target_dir}" "${value}")
            ans(newValue)
            #message("${reference}.${key} = '${value}' => '${newValue}'")

            map_set(${reference} "${key}" "${newValue}")
        endforeach()
    endforeach()




    json_write("${target_dir}/package.json" "${packageHandle}")


    return_ref(packageHandle)
  endfunction()  