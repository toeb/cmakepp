function(test)

  fwrite_data("pkg1/package.cmake" "{
    id:'mypkg', 
    version:'0.0.0', 
    include:'**'
  }" --json)


  ## event handler protocols all events fired

  ## arrange
  map_new()
  ans(context)
  event_addhandler(on_event "(name)->map_append(${context} events_emitted $name)")

  project_create(pr1)
  ans(project)

  assign(success = project.install(pkg1))

  map_set(${context} events_emitted) ## reset events

  ## act
  assign(success = project.uninstall(mypkg_0_0_0))

  ## assert
  assert(success)
  assertf({context.events_emitted} CONTAINS project_on_package_uninstall)

endfunction()