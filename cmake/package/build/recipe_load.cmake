  parameter_definition(recipe_load
    <--recipe{"recipe map or recipe file or uri of package"}:<data>>
    [--target-dir{"the directory where to load the recipe to"}=>target_dir:<string>]
    [--package-source{"use the specified package source"}=>source]
    [--refresh{"causes the package to reload even if it already exists"}]
    [--checked{"causes a validation of package content"}]
    "#loads a recipe"

    )
  function(recipe_load recipe)
    arguments_extract_defined_values(0 ${ARGC} recipe_load)    
    ans(args)
    ## todo: force stable package uris...?
    ## opt out if unstable 

    set(package_handle_filename package.json)


    if(NOT recipe)
        fatal("no recipe specified")
        return()
    endif()


    if(NOT target_dir)
      path(.)
      ans(target_dir)
    endif()


    is_map("${recipe}")
    ans(recipe_is_map)

    if(NOT recipe_is_map)
        map_new()
        ans(newRecipe)
        map_set(${newRecipe} query_uri "${recipe}")        
        set(recipe "${newRecipe}")
    endif()


    log("loading recipe {recipe.query_uri}...")


    if(NOT IS_DIRECTORY "${target_dir}")
        log("creating directory for recipe")
        mkdir("${target_dir}")
    endif()



    ## create a clone as to not modify recipe (safety first)
    map_clone_deep("${recipe}")
    ans(recipe)


    if(refresh)
        log("refreshing package - cleaning")
        rm(-r "${target_dir}")
    endif()    

 
    ## do everything relative from target_dir here
    pushd("${target_dir}" --create)


    set(package_handle)


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

        if(checked)

            log("checking consistency of source....")

            checksum_dir("${target_dir}/source")
            ans(source_checksum)
        
            map_tryget(${package_handle} content_checksum)
            ans(existing_checksum)

            if(NOT "${source_checksum}_" STREQUAL "${existing_checksum}_")
                popd()
                fatal("inconsistent source found (expected chksum '${existing_checksum}' but got  '${source_checksum}' )")
                return()
            endif()
        endif() 
    endif()


    map_set(${package_handle} recipe_dir "${target_dir}")



    map_merge(${package_handle} ${recipe})
    ans(package_handle)

    ## generate a build descriptor if it does not exist.
    package_handle_build_descriptor("${package_handle}")
    ans(build_descriptor)
    if(build_descriptor)        
        map_set(${package_handle} build_descriptor "${build_descriptor}")
    endif()

    fwrite_data("${package_handle_filename}" ${package_handle})



    popd()#target_dir

    return(${package_handle})    
  endfunction()  