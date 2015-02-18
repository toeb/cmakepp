function(test)
  
  fwrite_data("pkg1/package.cmake" "{
    id:'mypkg', 
    version:'0.0.0', 
    include:'**'
  }" --json)


  events_track(project_on_package_install project_on_package_load)
  ans(tracker)

  project_create(--force)
  ans(proj)
  assign(proj.remote = path_package_source())


  ## act
  assign(success = proj.install(pkg1))
  ## assert
  assert(success)  
  assertf("{tracker.project_on_package_install[0].args[0]}" STREQUAL "${proj}")
  
  assertf("{tracker.project_on_package_load[1].args[0]}" STREQUAL "${proj}")
  
  assign(installed_packages = proj.local.query("?*"))
  assert(installed_packages)
  


 




endfunction()