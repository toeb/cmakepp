function(test)

  fwrite_data("pkg1/package.cmake" "{
    id:'mypkg', 
    version:'0.0.0', 
    include:'**'
  }" --json)


  ## event handler protocols all events fired

  ## arrange

  events_track(project_on_package_materialized project_on_package_dematerializing)
  ans(tracker)
  project_create(pr1)
  ans(project)

  assign(project.remote = path_package_source())

  assign(success = project.materialize(pkg1))


  ## act
  assign(success = project.dematerialize(?id=mypkg))

  ## assert

  assign(installed_packages = project.local.query(?*))
  assert(NOT installed_packages)


  assert(success)
  assertf({tracker.project_on_package_dematerializing[0].args} CONTAINS "${project}")

endfunction()