function(test)

  project_open()
  ans(project)

  assign(project.project_descriptor.package_source 
    = mock_package_source(mock A "B=>C" D C "B=>E" E))


  project_change_dependencies(${project} A D)
  project_change_dependencies(${project} C)

  event_addhandler(project_on_package_materialized "[](proj mat_handle) message(FORMAT '{mat_handle.package_handle.uri} materialized')")
  event_addhandler(project_on_package_materializing "[](proj mat_handle) message(FORMAT '{mat_handle.package_handle.uri} materializing')")
  event_addhandler(project_on_package_dematerialized "[](proj mat_handle) message(FORMAT '{mat_handle.package_handle.uri} dematerializied')")
  event_addhandler(project_on_package_dematerializing "[](proj mat_handle) message(FORMAT '{mat_handle.package_handle.uri} dematerializing')")

  timer_start(t1)
  project_materialize_dependencies(${project})
  timer_print_elapsed(t1)
  assert(EXISTS "${test_dir}/packages/A-0.0.0")
  assert(EXISTS "${test_dir}/packages/C-0.0.0")
  assert(EXISTS "${test_dir}/packages/D-0.0.0")
  
  
  project_change_dependencies(${project} "C remove")
  project_materialize_dependencies(${project})

  assert(EXISTS "${test_dir}/packages/A-0.0.0")
  assert(NOT EXISTS "${test_dir}/packages/C-0.0.0")

  project_change_dependencies(${project} "B")
  project_materialize_dependencies(${project})
  assert(EXISTS "${test_dir}/packages/A-0.0.0")
  assert(EXISTS "${test_dir}/packages/B-0.0.0")
  assert(EXISTS "${test_dir}/packages/C-0.0.0")
  assert(EXISTS "${test_dir}/packages/E-0.0.0")


  project_change_dependencies(${project} "E conflict")
  ans(res)
  assert(NOT res)

  


endfunction()