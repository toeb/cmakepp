function(test)

  fwrite_data("pkg1/package.cmake" "{
    id:'mypkg', 
    version:'0.0.0', 
    include:'**'
  }" --json)


  ## event handler protocols all events fired

  ## arrange


  events_track(project_on_package_install project_on_package_load project_on_package_uninstall)
  ans(tracker)
  project_create(pr1)
  ans(project)

  assign(project.remote = path_package_source())

  assign(success = project.install(pkg1))


  ## act
  assign(success = project.uninstall(?id=mypkg))

  ## assert

  assign(installed_packages = project.local.query(?*))
  assert(NOT installed_packages)


  assert(success)
  assertf({tracker.project_on_package_uninstall[0].args} CONTAINS "${project}")

endfunction()