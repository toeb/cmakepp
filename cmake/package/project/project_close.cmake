## `(<project handle>)-><project file:<path>>`
##
## closes the specified project
##
## **events**
##  * `project_on_closing(<project handle>)`
##  * `project_on_closed(<project handle>)`
##  * see `project_unload`
##  * see `project_load`
function(project_close project_handle)
  event_emit(project_on_closing ${project_handle})

  #project_unload(${project_handle})

  map_tryget(${project_handle} content_dir)
  ans(project_content_dir)


  event_emit(project_on_close ${project_handle})


  pushd("${project_content_dir}" --create)

    assign(package_descriptor_file = project_handle.project_descriptor.package_descriptor_file)
    if(package_descriptor_file)
      map_tryget(${project_handle} package_descriptor)
      ans(package_descriptor)
      fwrite_data("${package_descriptor_file}" ${package_descriptor})
    endif()


    ## remove every package handles content_dir
    ## as persisting it would cause the project to
    ## become unportable
    assign(package_handles = project_handle.project_descriptor.package_materializations)
    map_values(${package_handles})
    ans(package_handles)

    foreach(package_handle ${package_handles})
      map_remove(${package_handle} content_dir)
    endforeach()

    assign(project_file = project_handle.project_descriptor.project_file)
    path_qualify(project_file)
    fwrite_data("${project_file}" "${project_handle}")
    
    map_set(${project_handle} content_dir ${project_content_dir})
    
  popd()


  event_emit(project_on_closed ${project_handle})

  return_ref(project_file)
endfunction()

