## `(<project handle>)-><project file:<path>>`
##
## closes the specified project.  All eventhandlers will be notified will emit their own events as well.
## after the project is closed it SHOULD NOT be modified.
##
## **events**
##  * `project_on_closing(<project handle>)`
##  * `project_on_close(<project handle>)`
##  * `project_on_closed(<project handle>)`
function(project_close project_handle)
  project_state_assert("${project_handle}" "opened")

  event_emit(project_on_closing ${project_handle})

  map_tryget(${project_handle} content_dir)
  ans(project_content_dir)

  event_emit(project_on_close ${project_handle})

  pushd("${project_content_dir}" --create)

    ## ensure portability by removing content_dir which is an absolute path
    assign(package_handles = project_handle.project_descriptor.package_materializations)
    map_values(${package_handles})
    ans(package_handles)

    foreach(package_handle ${package_handles})
      map_remove(${package_handle} content_dir)
    endforeach()

    assign(project_file = project_handle.project_descriptor.project_file)
    path_qualify(project_file)

    map_remove("${project}" content_dir)

  popd()

  project_state_change("${project_handle}" "closed")

  event_emit(project_on_closed ${project_handle})

  project_state_assert("${project_handle}" "^closed$")
  return_ref(project_file)
endfunction()
