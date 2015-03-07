function(test)

  project_open()
  ans(project)

  assign(project.project_descriptor.package_source 
    = mock_package_source(mock A "B=>C" D C "B=>E" E))


  project_change_dependencies(${project} A D)
  project_change_dependencies(${project} C)


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

  


endfunction()