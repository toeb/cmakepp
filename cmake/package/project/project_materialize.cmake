## `(<project handle> <volatile uri> <target dir>?)-><materialization handle>?`
##
## materializes a package for the specified project.
## if the package is already materialized the existing materialization handle
## is returned
## the target dir is treated relative to project root. if the target_dir
## is not given a target dir will be derived e.g. `<project root>/packages/mypackage-0.2.1-alpha`
##
## returns the materialization handle on success
## ```
## <materialization handle> ::= {
##   content_dir: <path> # path relative to project root
##   package_handle: <package handle>
## }
##
## 
## **events**: 
## * `[pwd=target_dir]project_on_package_materializing(<project handle> <package handle> <content_dir>)`
## * `[pwd=target_dir]project_on_package_materialized(<project handle> <package_handle> <content_dir>)`
##
## **sideffects**:
## * `IN` takes the package from the cache if it exits
## * `OUT` adds the specified package to the `package cache` if it does not exist 
## * `OUT` adds the materialization_handle to `project_handle.project_descriptor.package_materializations`
function(project_materialize project_handle package_uri)
  set(args ${ARGN})

  list_pop_front(args)
  ans(package_content_dir)

  map_tryget(${project_handle} uri)
  ans(project_uri)
  if("${project_uri}" STREQUAL "${package_uri}")
    return()
  endif()

  map_tryget(${project_handle} project_descriptor)
  ans(project_descriptor)

  map_import_properties(${project_descriptor} 
    package_materializations
    package_source
    package_cache
    dependency_dir
  )


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
  ans(materialization_handle)

  if(materialization_handle)
    return(${materialization_handle})
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


  ## make a qualified path
  path_qualify_from(${project_dir} ${package_content_dir})
  ans(package_content_dir)

  if("${package_content_dir}" STREQUAL "${project_dir}")
    message(WARNING"project_materialize: invalid package dir '${package_content_dir}'")
    return()
  endif()

  pushd(${installation_dir} --create)

    event_emit(project_on_package_materializing ${project_handle} ${materialization_handle})

    call(package_source.pull("${package_uri}" "${package_content_dir}"))
    ans(pull_handle)

    if(NOT pull_handle)
      popd()
      return()
    endif()

    map_set(${package_materializations} ${package_uri} ${materialization_handle})
    
    event_emit(project_on_package_materialized ${project_handle} ${materialization_handle})
  
  popd()

  return(${materialization_handle})
endfunction()

