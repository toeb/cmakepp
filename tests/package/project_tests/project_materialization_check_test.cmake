function(test)


  ## create a project and install two dependencies
  project_open("")
  ans(project)
  mock_package_source("mock" A B C)
  ans(package_source)
  assign(project.project_descriptor.package_source = package_source )

  project_install(${project} "A" "B")
  project_write(${project})


  ## check that when project is opened no materialization is missing
  events_track("project_on_package_ready" project_on_package_unready)
  ans(tracker)
  project_read()
  ans(project)
  assertf("{tracker.project_on_package_ready}" ISNULL)
  assertf("{tracker.project_on_package_unready}" ISNULL)


  rm("${test_dir}/packages/mock_A-0.0.0" -r)
  events_track(
    project_on_package_unready
    project_on_package_ready
    project_on_package_dematerialized
    project_on_package_dematerializing
    )
  ans(tracker)
  project_read()
  ans(project)
  assertf("{tracker.project_on_package_dematerialized}" ISNOTNULL)
  assertf("{tracker.project_on_package_dematerializing}" ISNOTNULL)

  assertf("{tracker.project_on_package_unready}" ISNOTNULL)
  assertf("{tracker.project_on_package_ready}" ISNULL)





endfunction()