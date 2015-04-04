function(test)

  project_open("")
  ans(project)

  assign(project.project_descriptor.package_source 
    = mock_package_source(mock A B D C E "B=>C" "B=>E"))


  project_change_dependencies(${project} A D)
  project_change_dependencies(${project} C)

  event_addhandler(project_on_package_materialized "[](proj mat_handle) message(FORMAT '{mat_handle.uri} materialized')")
  event_addhandler(project_on_package_materializing "[](proj mat_handle) message(FORMAT '{mat_handle.uri} materializing')")
  event_addhandler(project_on_package_dematerialized "[](proj mat_handle) message(FORMAT '{mat_handle.uri} dematerializied')")
  event_addhandler(project_on_package_dematerializing "[](proj mat_handle) message(FORMAT '{mat_handle.uri} dematerializing')")

  timer_start(t1)
  project_materialize_dependencies(${project})
  timer_print_elapsed(t1)
  assert(EXISTS "${test_dir}/packages/mock_A-0.0.0")
  assert(EXISTS "${test_dir}/packages/mock_C-0.0.0")
  assert(EXISTS "${test_dir}/packages/mock_D-0.0.0")
  
  
  project_change_dependencies(${project} "C remove")
  project_materialize_dependencies(${project})

  assert(EXISTS "${test_dir}/packages/mock_A-0.0.0")
  assert(NOT EXISTS "${test_dir}/packages/mock_C-0.0.0")

  project_change_dependencies(${project} "B")
  project_materialize_dependencies(${project})
  assert(EXISTS "${test_dir}/packages/mock_A-0.0.0")
  assert(EXISTS "${test_dir}/packages/mock_B-0.0.0")
  assert(EXISTS "${test_dir}/packages/mock_C-0.0.0")
  assert(EXISTS "${test_dir}/packages/mock_E-0.0.0")


  project_change_dependencies(${project} "E conflict")
  ans(res)
  assert(NOT res)

  


endfunction()