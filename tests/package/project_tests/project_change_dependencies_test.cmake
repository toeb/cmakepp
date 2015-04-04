function(test)

  project_open("")
  ans(project)



  mock_package_source(mock A B C D E "B=>C" "B=>E")
  ans(package_source)
  assign(project.project_descriptor.package_source = package_source)



  events_track(project_on_dependency_configuration_changed)
  ans(tracker)
  project_change_dependencies(${project})
  ans(res)

  assertf("{res.project:root}" STREQUAL "install")
  assertf({project.dependencies} ISNOTNULL)
  assertf({project.project_descriptor.installation_queue} ISNOTNULL)

  assertf("{tracker.project_on_dependency_configuration_changed[0].args[0]}" STREQUAL "${project}")
  assertf("{tracker.project_on_dependency_configuration_changed[0].args[1]}" STREQUAL "${res}")


  project_change_dependencies(${project})
  ans(res)
  map_keys(${res})
  ans(changes)
  assert(NOT changes)
  assertf("{tracker.project_on_dependency_configuration_changed}" COUNT 1)


  project_change_dependencies(${project} A)
  ans(res)
  map_keys(${res})
  ans(changes)
  assert(${changes} STREQUAL "mock:A")
  assertf("{tracker.project_on_dependency_configuration_changed[1].args[0]}" STREQUAL "${project}")
  assertf("{tracker.project_on_dependency_configuration_changed[1].args[1].mock:A}" STREQUAL "install")


  project_change_dependencies(${project} "A remove")
  ans(res)
  map_keys(${res})
  ans(changes)
  assert(${changes} STREQUAL "mock:A")
  assertf("{tracker.project_on_dependency_configuration_changed[2].args[0]}" STREQUAL "${project}")
  assertf("{tracker.project_on_dependency_configuration_changed[2].args[1].mock:A}" STREQUAL "uninstall")


  assertf("{project.project_descriptor.installation_queue}" COUNT 3)





  project_open("")
  ans(project)
  assign(project.project_descriptor.package_source = package_source)
  project_change_dependencies(${project} "A {content_dir:'asd'}")
  ans(res)
  json_print(${res})
  print_vars(project.package_descriptor.dependencies)
endfunction()