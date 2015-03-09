## `(<package handle> | <project dir> | <project file>)-><project handle>`
## 
## ```
## <project descriptor> ::= {
##    package_cache:
##    package_materializations:
##    dependency_configuration:
##    dependencies: {  }
##    dependency_dir:
##    config_dir:
##    project_file:
##    package_descriptor_file:
## }
## ```
##
## **events**
## * `project_on_opening(<project handle>)`
## * `project_on_opened(<project handle>)`
function(project_open)
  project_constants()
  pushd()
  set(args ${ARGN})
  set(project_handle)


    ## the following section loads the project handle if it 
    ## exists in default locations
    ## afterwards the content_dir is set correctly
    path("${args}")
    ans(project_file)
    if(EXISTS "${project_file}")
      if(EXISTS "${project_file}/${project_constants_project_file}")
        set(project_file "${project_file}/${project_constants_project_file}")
      endif()



      fread_data("${project_file}")
      ans(project_handle)
        

      if(project_handle)
        ## derive content dir from configured relative project file path
        assign(project_file_path = project_handle.project_descriptor.project_file)
        string_regex_escape("${project_file_path}")
        ans(project_file_path)
        string(REGEX REPLACE "(.*)\\/${project_file_path}$" "\\1" content_dir "${project_file}")

      else()
        path("")
        ans(content_dir)
      endif()
    else()
      path("")
      ans(content_dir)
    endif()


    ## if args are a project handle
    ## use them
    ref_isvalid("${args}")
    ans(is_ref)
    if(is_ref)
      set(project_handle ${args})
    endif()
    
    map_defaults("${project_handle}" "{
      uri:'project:root',
      project_descriptor:{
        package_cache:{},
        package_materializations:{},
        dependency_configuration:{},
        dependency_dir:$project_constants_dependency_dir,
        config_dir:$project_constants_config_dir,
        project_file:$project_constants_project_file
      }
    }")
    ans(project_handle)

    ## content_dir is always set so the project stays portable
    map_set(${project_handle} content_dir ${content_dir})

    ## load package descriptor from location if specified
    assign(package_descriptor_file = project_handle.project_descriptor.package_descriptor_file)
    if(package_descriptor_file AND EXISTS "${content_dir}/${package_descriptor_file}")
      fread_data("${content_dir}/${package_descriptor_file}")
      ans(package_descriptor)
      map_set(${project_handle} package_descriptor ${package_descriptor})
    endif()



    ## set project handle correctly
    assign(!project_handle.project_descriptor.project_handle = project_handle)
    
  popd()



  ## open complete - emit events

  event_emit(project_on_opening ${project_handle})
  
  ## remove missing materializations
  project_materialization_check_all(${project_handle})

  ## load the project
  project_load(${project_handle})


  event_emit(project_on_opened ${project_handle})

  return_ref(project_handle)
endfunction()
