function(test)
    
 



  return()
  path_package_source()
  ans(path_source)



  events_track(
    project_on_begin_load 
    project_on_load 
    project_on_package_load 
    project_on_packages_loaded
  )
  ans(tracker)

  ## event handler protocols all events fired
  ### load default non existing project

  ## arrange
  project_open()
  ans(project)



  ## act
  assign(success = project.load("pr0"))

  ## assert
  assert(success)
  assert(NOT EXISTS "${test_dir}/pr0")
  assertf({project.project_dir} STREQUAL "${test_dir}/pr0")
  assertf({project.config_dir} STREQUAL "${test_dir}/pr0/.cps")
  assertf({project.content_dir} STREQUAL "${test_dir}/pr0")
  assertf({project.dependency_dir} STREQUAL "${test_dir}/pr0/packages")


  ### load non existing project with custom config

  ## arrange
  project_open()
  ans(project)


  events_track(
    project_on_begin_load 
    project_on_load 
    project_on_package_load 
    project_on_packages_loaded
  )
  ans(tracker)
  ## act
  assign(success = project.load("pr1" 
    "{
      config_dir:'custom_config_dir',
      dependency_dir:'custom_package_dir',
      content_dir:'custom_content_dir'
    }"))

  ## assert
  assert(success)
  assert(NOT EXISTS "${test_dir}/pr1")
  assertf({project.project_dir} STREQUAL "${test_dir}/pr1")
  assertf({project.dependency_dir} STREQUAL "${test_dir}/pr1/custom_package_dir")
  assertf({project.config_dir} STREQUAL "${test_dir}/pr1/custom_config_dir")
  assertf({project.content_dir} STREQUAL "${test_dir}/pr1/custom_content_dir")
  assertf({project.local.directory} STREQUAL "${test_dir}/pr1/custom_package_dir")

  assertf({tracker.event_ids} CONTAINS project_on_begin_load)
  assertf({tracker.event_ids} CONTAINS project_on_load)



  ### load existing project with default layout with installed packages
    
  events_track(
    project_on_begin_load 
    project_on_load 
    project_on_package_load 
    project_on_packages_loaded
  )
  ans(tracker)
  ## arrange
  fwrite_data("pkg1/package.cmake" "{id:'mypkg',version:'0.0.0',includes:'**'}" --json)
  managed_package_source("project" "${test_dir}/pr2/packages")
  ans(managed_source)

  assign(success = managed_source.push(${path_source} pkg1))
  project_open()
  ans(project)


  ## act
  assign(success = project.load("pr2"))


  ## assert
  assert(success)
  assertf({project.project_dir} STREQUAL "${test_dir}/pr2")
  assertf({project.local.directory} STREQUAL "${test_dir}/pr2/packages")


  assertf({tracker.event_ids} CONTAINS project_on_begin_load)
  assertf({tracker.event_ids} CONTAINS project_on_load)
  assertf({tracker.event_ids} CONTAINS project_on_package_load)
  assertf({tracker.event_ids} CONTAINS project_on_packages_loaded)

endfunction()