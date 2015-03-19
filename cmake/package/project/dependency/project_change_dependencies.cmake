## `(<project handle> <action...>)-><dependency changeset>`
##
## changes the dependencies of the specified project handle
## expects the project_descriptor to contain a valid package source
## returns the dependency changeset 
## **sideffects**
## * adds new '<dependency configuration>' `project_handle.project_descriptor.installation_queue`
## **events**
## * `project_on_dependency_configuration_changed(<project handle> <changeset>)` is called if dpendencies need to be changed
function(project_change_dependencies project_handle)
  set(args ${ARGN})

  map_tryget(${project_handle} project_descriptor)
  ans(project_descriptor)

  map_import_properties(${project_descriptor} 
    package_source
    package_cache
    )
  ## check for package source
  if(NOT package_source)
 #   message(FATAL_ERROR "no package source set up in project handle")
  endif()   

  ## get previous_configuration
  map_peek_back(${project_descriptor} installation_queue)
  ans(previous_configuration)

  if(NOT previous_configuration)
    map_new()
    ans(previous_configuration)
  endif()

  ## 
  package_dependency_configuration_update(
    "${package_source}"
    "${project_handle}"
    ${args}
    --cache ${package_cache}
    )
  ans(configuration)

  ## invalid configuration
  if(NOT configuration)
    return()
  endif()

  ## compute changeset  and return
  package_dependency_configuration_changeset(
    ${previous_configuration} 
    ${configuration}
  )
  ans(changeset)

  map_isempty(${changeset})
  ans(is_empty)
  if(is_empty)
    return_ref(changeset)
  endif()

  ## add the changeset to the installation queue
  map_append(${project_descriptor} installation_queue ${configuration})

  ## emit event
  event_emit(project_on_dependency_configuration_changed ${project_handle} ${changeset})

  return_ref(changeset)
endfunction()
