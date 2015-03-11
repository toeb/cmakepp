## `(<package handle> | <project dir> | <project file>)-><project handle>`
## 
##  Opens a project at `<project dir>` which defaults to the current directory (see `pwd()`). 
##  If a project file is specified it is openend and the project dir is derived.  
## 
##  Checks wether the project is consistent and if not acts accordingly. Loads the project and all its dependencies
##  also loads all materialized packages which are not part of the project's dependency graph
## 
## **returns** 
## * `<project handle>` the handle to the current project (contains the `project_descriptor`) 
## 
## **events**
## * `project_on_opening(<project handle>)` emitted when the `<project handle>` exists but nothing is loaded yet
## * `project_on_opened(<project handle>)` emitted after the project was checked and loaded
## * events emitted by `project_load`
## * events emitted by `project_materialization_check`
## * events have access to the follwowing in their scope: 
##   * `project_dir:<qualified path>` the location of this projects root directory
##   * `project_handle:<project handle>` the handle to the project 
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

  ## setup scope for events
  set(project_dir ${content_dir})
  set(project_handle ${project_handle})

  ## open starting - emit events

  event_emit(project_on_opening ${project_handle})
  
  ## perform open (calls all registered events for project open)
  event_emit(project_on_open ${project_handle})

  ## open complete
  event_emit(project_on_opened ${project_handle})

  return_ref(project_handle)
endfunction()
