
## 
## package_handle with build_descriptor:
## {
##      config,
##      generator,
##         
## }
## returns a  `build_info` object
## ``` { params: <build_params>, generator: <generator_instance>? }```
  parameter_definition(package_handle_build
    <--package-handle{"recipe map or recipe file"}=>package_handle:<data>>
    <--parameters{"parameters"}=>params:<data>> 
    [--build-dir{"the directory where to perform the build, relative to target_dir"}=>build_dir:<string>="build"]       
    [--install-dir{"the directory where the build result is moved, relative to target_dir"}=>install_dir:<string>="install"]
    [--target-dir{"default is pwd"}=>target_dir:<string>]
    [--clean{"deletes all intermediary results after build"}:<bool>=true]
    "#builds a package handle containing a build_descriptor"
    "#the build_descriptor gets at least the build_dir, install_dir and content_dir as parameters"
    "#the build_descriptor needs to ensure that the build results are stored in install_dir"
    )

function(package_handle_build )
    arguments_extract_defined_values(0 ${ARGC} package_handle_build)    


    pushd("${target_dir}" --create)
    ans(target_dir)
    
    path_qualify_from("${target_dir}" "${build_dir}")
    ans(build_dir)
    
    path_qualify_from("${target_dir}" "${install_dir}")
    ans(install_dir)

   

    map_tryget(${package_handle} content_dir)
    ans(content_dir)

    map_tryget(${package_handle} build_descriptor)
    ans(build_descriptor)

    ## create copy
    map_clone_deep("${build_descriptor}")
    ans(build_descriptor)


    ## todo rename build_descriptor to generation_descriptor
    ## keep list of build descriptors containing dir where install lies, parameters
    ## 

    map_set(${params} "install_dir" "${install_dir}")        
    map_set(${params} "build_dir" "${build_dir}")        
    map_set(${params} "content_dir" "${content_dir}")



    map_template_evaluate_scoped(${params} ${build_descriptor})
    ans(evaluated_build_descriptor)
    map_conditional_evaluate("" ${evaluated_build_descriptor})
    ans(evaluated_build_descriptor)


    map_new()
    ans(build_info)

    map_set(${build_info} params ${params})    
    map_set(${build_info} build_descriptor ${evaluated_build_descriptor})



    log("executing build task...")

    build_task_execute("${evaluated_build_descriptor}" ${params})
    ans(success)
    if(NOT success)
        error("...failed to execute build task")
        popd() ## target_dir
        return()
    endif()

    if(clean)
        log("cleaning build dir...")
        map_tryget(${params} build_dir)
        ans(build_dir)
        rm(-r "${build_dir}")
    endif()

    

    log("...done executing build task.")


    popd() ## target_dir
    return("${build_info}")

        
endfunction()