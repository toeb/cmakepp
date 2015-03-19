function(test)
  mock_package_source(mock A B C)
  ans(package_source)

  project_open(".")
  ans(project)

  assign(project.project_descriptor.package_source = package_source)


  events_track(project_on_package_materializing project_on_package_materialized)
  ans(tracker)

  timer_start(t1)
  project_materialize("${project}" "mock:A")
  ans(handle)
  timer_print_elapsed(t1)

  assert(handle)
  assertf("{handle.content_dir}" STREQUAL "${test_dir}/packages/mock_A-0.0.0" )
  assertf("{handle.materialization_descriptor.content_dir}" STREQUAL "packages/mock_A-0.0.0" )
  assertf("{project.project_descriptor.package_materializations.mock:A}" STREQUAL "${handle}")
  assertf("{tracker.project_on_package_materializing[0].args[0]}" STREQUAL "${project}")
  assertf("{tracker.project_on_package_materializing[0].args[1]}" STREQUAL "{handle}")
  assertf("{tracker.project_on_package_materialized[0].args[0]}" STREQUAL "${project}")
  assertf("{tracker.project_on_package_materialized[0].args[1]}" STREQUAL "{handle}")
  assert(EXISTS "${test_dir}/packages/mock_A-0.0.0")

  timer_start(t2)
  project_materialize("${project}" "meh")
  ans(handle)
  timer_print_elapsed(t2)

  assert(NOT handle)


  project_materialize(${project} "B" "mydir")
  ans(res)
  assertf("{res.materialization_descriptor.content_dir}" STREQUAL "mydir")
  assertf("{res.content_dir}" STREQUAL "${test_dir}/mydir")
  assert(EXISTS "${test_dir}/mydir")


endfunction()