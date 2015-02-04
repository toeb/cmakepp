function(test)
  
  fwrite_data("pkg1/package.cmake" "{
    id:'mypkg', 
    version:'0.0.0', 
    include:'**'
  }" --json)

  
  ## arrange
  map_new()
  ans(context)
  ## event handler protocols all events fired
  event_addhandler(on_event "(name)->map_append(${context} events_emitted $name)")

  project_create(--force)
  ans(proj)
  assign(proj.remote = path_package_source())

  map_set(${context} events_emitted) ## reset events

  ## act
  assign(success = proj.install(pkg1))

  ## assert
  assert(success)  
  assertf({context.events_emitted} CONTAINS project_on_package_install)
  assertf({context.events_emitted} CONTAINS project_on_package_load)
  assign(installed_packages = proj.dependency_source.query("?*"))
  assert(${installed_packages} CONTAINS "${success}" )



 




endfunction()