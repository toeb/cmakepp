## `(<project handle> <package uri>)-><package handle>`
##
## **sideeffects**
## * removes `project_handle.project_descriptor.package_installations.<package_uri>` 
## * removes `package_handle.materialization_descriptor`
## 
##
## **events**:
## * `[pwd=package content dir]project_on_package_dematerializing(<project handle> <package handle>)`
## * `[pwd=package content dir]project_on_package_dematerialized(<project handle> <package handle>)`
## 
function(project_dematerialize project_handle package_uri)
  map_import_properties(${project_handle} project_descriptor)
  map_tryget(${project_handle} uri)
  ans(project_uri)

  map_import_properties(${project_descriptor} 
    package_source
    package_cache
    package_materializations

    )


  ## special treatment for project - dematerialization is allowed
  ## however it will only be virtual and not actualle affect the
  ## content_dir
  if("${project_uri}" STREQUAL "${package_uri}")
    map_tryget(${package_materializations} ${project_uri})
    ans(project_handle)
    map_tryget(${project_handle} content_dir)
    ans(content_dir)
    pushd(${content_dir})
      event_emit(project_on_package_dematerializing ${project_handle} ${project_handle})
        map_remove(${package_materializations} ${project_uri})    
        map_remove(${project_handle} materialization_descriptor)
      event_emit(project_on_package_dematerialized ${project_handle} ${project_handle})
    popd()
    return(${project_handle})
  endif()


  if(NOT package_source)
    message(FATAL_ERROR "project_dematerialize: no package source available")
  endif()

  package_source_resolve(${package_source} ${package_uri} --cache ${package_cache})
  ans(package_handle)

  if(NOT package_handle)
    return()
  endif()

  map_tryget(${package_handle} uri)
  ans(package_uri)

  map_tryget(${package_handle} materialization_descriptor)
  ans(materialization_handle)

  if(NOT materialization_handle)
    return()
  endif() 

  map_tryget(${project_handle} content_dir)
  ans(project_dir)

  map_tryget(${materialization_handle} content_dir)
  ans(package_content_dir)

  path_qualify_from(${project_dir} ${package_content_dir})
  ans(package_content_dir)

  ## emit events before and after removing package
  ## should also work if package doesnot exist anymore
  pushd("${package_content_dir}" --create)  

    event_emit(project_on_package_dematerializing ${project_handle} ${package_handle})

    map_remove(${package_materializations} ${package_uri})
    map_remove(${package_handle} materialization_descriptor)
    ## delete package content dir

    if("${project_dir}" STREQUAL "${package_content_dir}")
      message(WARNING "project_dematerialize: package dir is project dir will not delete")
    else()
      rm(-r "${package_content_dir}")
    endif()


    event_emit(project_on_package_dematerialized ${project_handle} ${package_handle})
  popd()
  return(${package_handle})  
endfunction()
