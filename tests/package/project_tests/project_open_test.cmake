function(test)

  project_open(".")
  ans(project)
  assert(project)
  assertf({project.content_dir} STREQUAL "${test_dir}")
  assertf({project.project_descriptor.project_file} STREQUAL .cps/project.scmake)
  assertf({project.project_descriptor.dependency_dir} STREQUAL packages)
  assertf({project.project_descriptor.config_dir} STREQUAL .cps)
  assertf({project.project_descriptor.package_cache} ISNOTNULL)
  assertf({project.project_descriptor.package_materializations} ISNOTNULL)
  assertf({project.project_descriptor.dependency_configuration} ISNOTNULL)
  assertf({project.uri} STREQUAL "project:root")
  assertf({project.package_descriptor} ISNOTNULL)
  
  project_open("dir1")
  ans(project)
  assert(project)
  assertf({project.content_dir} STREQUAL "${test_dir}/dir1")


  project_open("dir1" "{package_descriptor:{id:'mypkg'}}")
  ans(project)
  assert(project)
  assertf({project.package_descriptor.id} STREQUAL "mypkg") 


  ## remove revent handlers 
  event_clear(project_on_new)
  event_clear(project_on_opening)
  event_clear(project_on_open)
  event_clear(project_on_opened)
  #check for events
  
  events_track(project_on_new project_on_opening project_on_open project_on_opened)
  ans(tracker)


  project_open(".")
  ans(project)
  project_state_assert("${project}" opened) 
  assertf({tracker.project_on_new[0].args[0]} STREQUAL "${project}")
  assertf({tracker.project_on_opening[0].args[0]} STREQUAL "${project}")
  assertf({tracker.project_on_open[0].args[0]} STREQUAL "${project}")
  assertf({tracker.project_on_opened[0].args[0]} STREQUAL "${project}")



  events_track(project_on_new project_on_opening project_on_open project_on_opened)
  ans(tracker)

  map_new()
  ans(project)
  project_open("." "${project}")
  ans(project)
  project_state_assert("${project}" opened) 

  assertf({tracker.project_on_new} ISNOTNULL)
  assertf({tracker.project_on_opening[0].args[0]} STREQUAL "${project}")
  assertf({tracker.project_on_open[0].args[0]} STREQUAL "${project}")
  assertf({tracker.project_on_opened[0].args[0]} STREQUAL "${project}")


  events_track(project_on_new project_on_opening project_on_open project_on_opened)
  ans(tracker)

  assign(!project.project_descriptor.state = 'closed')
  project_open("." "${project}")
  ans(project)
  project_state_assert("${project}" opened) 

  assertf({tracker.project_on_new} ISNULL)
  assertf({tracker.project_on_opening[0].args[0]} STREQUAL "${project}")
  assertf({tracker.project_on_open[0].args[0]} STREQUAL "${project}")
  assertf({tracker.project_on_opened[0].args[0]} STREQUAL "${project}")



endfunction()