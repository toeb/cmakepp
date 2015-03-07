
  ## `(<project handle> <action...>)-><dependency changeset>`
  ##
  ## changes the dependencies of the specified project handle
  ## expects the project_descriptor to contain a valid package source
  ## returns the dependency changeset
  ## **sideffects**
  ## * sets `project_descriptor`'s `dependency_configuration` property
  ## * adds the changeset to the `project_descriptor`'s ' `installation_queue` 
  ## **events**
  ## * `project_on_dependency_configuration_changed(<project handle> <changeset>)` is called if dpendencies need to be changed
  function(project_change_dependencies project_handle)
    set(args ${ARGN})

    ## check for package source
    assign(package_source = project_handle.project_descriptor.package_source)
    if(NOT package_source)
      message(FATAL_ERROR "no package source set up in project handle")
    endif()   

    ## get previous_configuration
    assign(previous_configuration = project_handle.project_descriptor.dependency_configuration)
    if(NOT previous_configuration)
      map_new()
      ans(previous_configuration)
    endif()

    assign(cache = project_handle.project_descriptor.package_cache)
   
    package_dependency_configuration_update(
      ${package_source}
      ${project_handle}
      ${args}
      --cache ${cache}

      )
    ans(configuration)

    ## set the new configuration
    assign(!project_handle.project_descriptor.dependency_configuration = configuration)

    ## compute changeset  and return
    package_dependency_configuration_changeset(
      ${previous_configuration} 
      ${configuration}
    )
    ans(changeset)

    ## add the changeset to the installation queue
    assign(!project_handle.project_descriptor.installation_queue[] = changeset)

    ## emit event
    event_emit(project_on_dependency_configuration_changed ${project_handle} ${changeset})

    return_ref(changeset)
  endfunction()
