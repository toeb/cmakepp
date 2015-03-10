function(test)


  ## create a project and install two dependencies
  project_open()
  ans(project)
  mock_package_source("mock" A B C)
  ans(package_source)
  assign(project.project_descriptor.package_source = package_source )

  project_install(${project} "A" "B")
  project_close(${project})


  ## check that when project is opened no materialization is missing
  events_track("project_on_package_materialization_missing")
  ans(tracker)
  project_open()
  ans(project)
  assertf("{tracker.project_on_package_materialization_missing}" ISNULL)


  rm("${test_dir}/packages/mock_A-0.0.0" -r)
  events_track(
    project_on_package_materialization_missing
    project_on_package_dematerialized
    project_on_package_dematerializing
    )
  ans(tracker)
  project_open()
  ans(project)
  assertf("{tracker.project_on_package_materialization_missing}" ISNOTNULL)
  assertf("{tracker.project_on_package_materialization_missing[0].args[0]}" STREQUAL "${project}")
  assertf("{tracker.project_on_package_materialization_missing[0].args[1].uri}" STREQUAL "mock:A")
  assertf("{tracker.project_on_package_dematerialized}" ISNOTNULL)
  assertf("{tracker.project_on_package_dematerializing}" ISNOTNULL)





endfunction()