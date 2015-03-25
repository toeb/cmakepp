## `(<project handle> <volatile uri> <target dir>?)-><package handle>?`
##
## materializes a package for the specified project.
## if the package is already materialized the existing materialization handle
## is returned
## the target dir is treated relative to project root. if the target_dir
## is not given a target dir will be derived e.g. `<project root>/packages/mypackage-0.2.1-alpha`
##
## returns the package handle on success
## 
## **events**: 
## * `[pwd=target_dir]project_on_package_materializing(<project handle> <package handle>)`
## * `[pwd=target_dir]project_on_package_materialized(<project handle> <package handle>)`
##
## **sideffects**:
## * `IN` takes the package from the cache if it exits
## * adds the specified package to the `package cache` if it does not exist 
## * `project_handle.project_descriptor.package_materializations.<package uri> = <materialization handle>`
## * `package_handle.materialization_descriptor = <materialization handle>`
##
## ```
## <materialization handle> ::= {
##   content_dir: <path> # path relative to project root
##   package_handle: <package handle>
## }
## ```
function(project_materialize project_handle package_uri)
  set(args ${ARGN})

  list_pop_front(args)
  ans(package_content_dir)

  map_tryget(${project_handle} uri)
  ans(project_uri)

  map_tryget(${project_handle} project_descriptor)
  ans(project_descriptor)

  map_import_properties(${project_descriptor} 
    package_materializations
    package_source
    package_cache
    dependency_dir
  )

  ## special treatment  if package uri is project uri
  ## project is already materialized however 
  ## events still need to be emitted / materialization_handle 
  ## needs to be created
  if("${project_uri}" STREQUAL "${package_uri}")
    map_tryget(${package_materializations} ${project_uri})
    ans(materialization_handle)
    if(NOT materialization_handle)
      map_new()
      ans(materialization_handle)
      map_set(${materialization_handle} content_dir "")
      map_set(${materialization_handle} package_handle ${project_handle})
      event_emit(project_on_package_materializing ${project_handle} ${project_handle})
      map_set(${package_materializations} "${package_uri}" ${project_handle})
      map_set(${project_handle} materialization_descriptor ${materialization_handle})
      event_emit(project_on_package_materialized ${project_handle} ${project_handle})
    endif()
    return(${project_handle})
  endif()

  if(NOT package_source)
    message(FATAL_ERROR "project_materialize: no package source available")
  endif()

  ## get a package handle from uri
  package_source_resolve(${package_source} "${package_uri}" --cache ${package_cache})
  ans(package_handle)
  if(NOT package_handle)
    return()
  endif()


  map_tryget(${project_handle} content_dir)
  ans(project_dir)

  map_tryget(${package_handle} uri)
  ans(package_uri)

  map_tryget(${package_materializations} ${package_uri})
  ans(is_materialized)

  if(is_materialized)
    return(${package_handle})
  endif()

  
  ## generate the content dir for the package 
  if("${package_content_dir}_" STREQUAL "_")
    project_derive_package_content_dir(${project_handle} ${package_handle})
    ans(package_content_dir)
  endif()
  

  ## create materialization handle
  map_new()
  ans(materialization_handle)
  map_set(${materialization_handle} package_handle ${package_handle})
  map_set(${materialization_handle} content_dir ${package_content_dir})
  map_set(${package_handle} materialization_descriptor ${materialization_handle})

  ## make a qualified path
  path_qualify_from(${project_dir} ${package_content_dir})
  ans(package_content_dir)

  map_set(${package_handle} content_dir ${package_content_dir})

  if("${package_content_dir}" STREQUAL "${project_dir}")
    message(WARNING"project_materialize: invalid package dir '${package_content_dir}'")
    return()
  endif()

  pushd(${installation_dir} --create)

    event_emit(project_on_package_materializing ${project_handle} ${package_handle})

    call(package_source.pull("${package_uri}" "${package_content_dir}"))
    ans(pull_handle)
    ## todo content dir might not be the same
    
    if(NOT pull_handle)
      map_remove(${package_handle} materialization_descriptor)
      popd()
      return()
    endif()

    map_set(${package_materializations} ${package_uri} ${package_handle})

    event_emit(project_on_package_materialized ${project_handle} ${package_handle})
  
  popd()


  return(${package_handle})
endfunction()

