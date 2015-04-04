function(test)

  mock_package_source(mock A B C)
  ans(package_source)

  project_open("")
  ans(project)

  assign(project.project_descriptor.package_source = package_source)

  events_track(
    project_on_package_dematerializing 
    project_on_package_dematerialized
    )
  ans(tracker)


  project_materialize(${project} A)
  project_materialize(${project} B)

  assert(EXISTS "${test_dir}/packages/mock_A-0.0.0")
  timer_start(t1)
  project_dematerialize(${project} A)
  ans(handle)
  timer_print_elapsed(t1)
  assert(handle)
  assert(NOT EXISTS "${test_dir}/packages/mock_A-0.0.0")
  assertf("{handle.materialization_descriptor}" ISNULL)
  assertf("{project.project_descriptor.package_materializations.mock:A}" ISNULL)
  assertf("{tracker.project_on_package_dematerializing[0].args[0]}" STREQUAL "${project}")
  assertf("{tracker.project_on_package_dematerializing[0].args[1]}" STREQUAL "{handle}")
  assertf("{tracker.project_on_package_dematerialized[0].args[0]}" STREQUAL "${project}")
  assertf("{tracker.project_on_package_dematerialized[0].args[1]}" STREQUAL "{handle}")

  timer_start(t2)
  project_dematerialize(${project} A)
  ans(handle)
  timer_print_elapsed(t2)
  assert(NOT handle)






endfunction()