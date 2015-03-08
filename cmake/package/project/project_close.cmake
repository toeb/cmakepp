## `(<project handle>)-><project file:<path>>`
##
## **events**
## * `project_on_closing(<project handle>)`
## * `project_on_closed(<project handle>)`
## * see `project_unload`
## * see `project_load`
function(project_close project_handle)
  event_emit(project_on_closing ${project_handle})

  project_unload(${project_handle})

  map_tryget(${project_handle} content_dir)
  ans(project_content_dir)



  pushd("${project_content_dir}" --create)

    assign(package_descriptor_file = project_handle.project_descriptor.package_descriptor_file)
    if(package_descriptor_file)
      map_tryget(${project_handle} package_descriptor)
      ans(package_descriptor)
      fwrite_data("${package_descriptor_file}" ${package_descriptor})
    endif()
    ## content dir is removed so that project stays portable
    map_remove(${project_handle} content_dir)

    assign(project_file = project_handle.project_descriptor.project_file)
    path_qualify(project_file)
    fwrite_data("${project_file}" "${project_handle}")

    ## after writing content dir is added so project  continues to work
    map_set(${project_handle} content_dir ${project_content_dir})
    
  popd()


  event_emit(project_on_closed ${project_handle})

  project_load(${project_handle})


  return_ref(project_file)
endfunction()


