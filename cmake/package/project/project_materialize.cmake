
##
## **events**: 
## * `project_on_package_materializing(<project handle> <package handle> <content_dir>)`
## * `project_on_package_materialized(<project handle> <package_handle> <content_dir>)`
function(project_materialize project_handle package_handle)
  if("${project_handle}" STREQUAL "${package_handle}")
    return(false)
  endif()

  map_tryget(${project_handle} project_descriptor)
  ans(project_descriptor)

  map_tryget(${project_descriptor} package_installations)
  ans(installations)

  map_tryget(${project_handle} content_dir content_dir)
  ans(project_dir)

  map_tryget(${package_handle} uri)
  ans(package_uri)

  map_tryget(${installations} ${package_uri})
  ans(package_installation)

  if(package_installation)
    message(FORMAT "project_materialize: package is already installed ${package_uri} at {package_installation.content_dir}")
    return(false)
  endif()


  map_tryget(${project_descriptor} package_source)    
  ans(package_source)

  if(NOT package_source)
    message(FATAL_ERROR "project_materialize: no package source specified")
  endif()
  
  ## generate the content dir for the package handle

  map_tryget(${project_descriptor} dependency_dir)
  ans(dependency_dir)

  format("{package_handle.package_descriptor.id}-{package_handle.package_descriptor.version}")
  ans(package_content_dir)
  string_normalize("${package_content_dir}")
  ans(package_content_dir)
  set(package_content_dir "${dependency_dir}/${package_content_dir}")

  map_new()
  ans(package_installation)
  map_set(${package_installation} content_dir ${package_content_dir})
  map_set(${installations} ${package_uri} ${package_installation})

  path_qualify_from(${project_dir} ${package_content_dir})
  ans(package_content_dir)

  pushd(${installation_dir} --create)
  event_emit(project_on_package_materializing ${project_handle} ${package_handle} ${package_content_dir})

  call(package_source.pull("${package_uri}" "${package_content_dir}"))
  ans(pull_handle)

  if(NOT pull_handle)
    message(FATAL_ERROR "could not pull ${package_uri}")
  endif()

  event_emit(project_on_package_materialized ${project_handle} ${package_handle} ${package_content_dir})
  popd()

  return(${pull_handle})
endfunction()


