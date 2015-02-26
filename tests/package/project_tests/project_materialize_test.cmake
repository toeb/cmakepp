function(test)
  
  fwrite_data("pkg1/package.cmake" "{
    id:'mypkg', 
    version:'0.0.0', 
    include:'**'
  }" --json)


  events_track(project_on_package_materialized)
  ans(tracker)

  project_create(--force proj1)
  ans(proj)
  assign(proj.remote = path_package_source())


  ## act
  assign(success = proj.materialize(pkg1))

  ## assert
  assert(success)  
  assertf("{tracker.project_on_package_materialized[0].args[0]}" STREQUAL "${proj}")
 # assertf("{tracker.project_on_package_load[1].args[0]}" STREQUAL "${proj}")
  assign(installed_packages = proj.local.query("?*"))
  assert(installed_packages)
  

  ## materialize same project - should not work
  assign(success = proj.materialize(pkg1))
  assert(NOT success)




  





endfunction()