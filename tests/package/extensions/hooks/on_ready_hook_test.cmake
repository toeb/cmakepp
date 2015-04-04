function(test)

  mock_package_source(mock A)
  ans(package_source)
  map_new()


  
  ans(context)
  assign(!package_source.metadata.A.hooks.on_ready = "'[]() map_append(${context} ready {{ARGN}})'")
  
  project_open(.)
  ans(project)
  assign(project.project_descriptor.package_source = package_source)
  assign(!project.package_descriptor.hooks.on_ready = "'[]() map_append(${context} ready {{ARGN}})'")
  

  project_change_dependencies(${project} A)
  
  project_materialize(${project} "project:root")
  project_materialize(${project} A)
  ans(ph)


  assertf("{context.ready[0]}" STREQUAL "${project}")
  assertf("{context.ready[1]}" STREQUAL "${ph}")
  assertf("{context.ready[2]}" STREQUAL "${project}")
  assertf("{context.ready[3]}" STREQUAL "${project}")


endfunction()