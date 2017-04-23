

  parameter_definition(recipe_binary
    <--package-handle{"recipe map or recipe file"}=>package_handle:<data>>
    <--parameters{"parameters"}=>param:<data>>        
    "#loads a recipe"
    )

function(recipe_binary )
    arguments_extract_defined_values(0 ${ARGC} recipe_binary)    

    map_tryget(${param} recipe_dir)
    ans(recipe_dir)

    pushd("${recipe_dir}")


    checksum_object("${param}")
    ans(param_checksum)

    


    pushd(${param_checksum} --create)
    ans(target_dir)


    map_tryget(${package_handle} content_dir)
    ans(content_dir)


    map_tryget(${package_handle} build_descriptor)
    ans(build_descriptor)





    map_set(${param} "build_dir" "${target_dir}/build")
    map_set(${param} "install_dir" "${target_dir}/stage")
    map_set(${param} "content_dir" "${content_dir}")

    json_print(${param})

    map_template_evaluate_scoped(${param} ${build_descriptor})
    ans(evaluated_build_descriptor)
    map_conditional_evaluate("" ${evaluated_build_descriptor})
    ans(evaluated_build_descriptor)



    log("executing build task...")
    build_task_execute("${evaluated_build_descriptor}" ${param})
    ans(success)
    if(NOT success)
        error("...failed to execute build task")
        return()
    endif()

    log("...done executing build task.")



    popd()    
    popd()

    return("${target_dir}/stage")

    return()

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


    map_append(${package_handle} builds "${evaluated_build_descriptor}")
    map_append(${package_handle} binaries "${evaluated_binary_descriptor}")



    map_dfs_references_once(${package_handle})
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




    json_write("${target_dir}/package.json" "${package_handle}")


    return_ref(package_handle)

        
endfunction()




  parameter_definition(recipe_load
    <--recipe{"recipe map or recipe file"}:<data>>
    [--target-dir{"the directory where to load the recipe to"}=>target_dir:<string>]
    [--package-source{"use the specified package source"}=>source]
    "#loads a recipe"
    )
  function(recipe_load recipe)
    arguments_extract_defined_values(0 ${ARGC} recipe_load)    

    set(package_handle_filename package.json)


    if(NOT recipe)
        error("no recipe specified")
        return()
    endif()


    if(NOT target_dir)
      path(.)
      ans(target_dir)
    endif()


    log("loading recipe {recipe.query_uri}...")


    if(NOT IS_DIRECTORY "${target_dir}")
        log("creating directory for recipe")
        mkdir("${target_dir}")
    endif()



    ## create a clone as to not modify recipe (safety first)
    map_clone_deep("${recipe}")
    ans(recipe)

    

 
    ## do everything relative from target_dir here
    pushd("${target_dir}")




    ## read existing package handle
    fread_data("${package_handle_filename}")
    ans(package_handle)


    if(NOT package_handle)
        log("package does not exist yet. ")
        
        if(NOT source)
            log("no package source specified - using default package source")
            default_package_source()
            ans(source)
        endif()    

        ## get package
        map_tryget(${recipe} query_uri)
        ans(query_uri)

        log("pulling package '${query_uri}'...")
        package_source_push_path(${source} "${query_uri}" => "${target_dir}/source")
        ans(package_handle)

        
        checksum_dir("${target_dir}/source")
        ans(source_checksum)

        map_set(${package_handle} content_checksum ${source_checksum})

        log("...done. pulled '${query_uri}' (source chksum: ${source_checksum})")


    else()
        log("found package at '${target_dir}'")


        log("checking consistency of source....")

        checksum_dir("${target_dir}/source")
        ans(source_checksum)
        
        map_tryget(${package_handle} content_checksum)
        ans(existing_checksum)

        if(NOT "${source_checksum}_" STREQUAL "${existing_checksum}_")
            error("inconsistent source found (expected chksum '${existing_checksum}' but got  '${source_checksum}' )")
            popd()
            return()
        endif()

    endif()


    map_set(${package_handle} recipe_dir "${target_dir}")



    map_merge(${package_handle} ${recipe})
    ans(package_handle)


    fwrite_data("${package_handle_filename}" ${package_handle})



 ##   map_tryget(${recipe} parameters)
  #  ans(parameters)


    ## todo:  handle multiple binary dscritpors
    ## set build config 
    ## so that it can be built by different function






    return(${package_handle})


    

    map_tryget(${package_handle} content_dir)
    ans(content_dir)



    map_tryget(${recipe} build_descriptor)
    ans(build_descriptor)
    map_set(${package_handle} build_descriptor ${build_descriptor})
    
    map_tryget(${recipe} binary_descriptor)
    ans(binary_descriptor)
    map_set(${package_handle} binary_descriptor ${binary_descriptor})


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


    map_append(${package_handle} builds "${evaluated_build_descriptor}")
    map_append(${package_handle} binaries "${evaluated_binary_descriptor}")



    map_dfs_references_once(${package_handle})
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




    json_write("${target_dir}/package.json" "${package_handle}")


    return_ref(package_handle)
  endfunction()  