function(test)

  mock_package_source(mock A B "A=>B")
  ans(package_source)
  map_new()


  
  ans(context)
  assign(!package_source.metadata.A.hooks.on_unready = "'[]() map_append(${context} unready {{ARGN}})'")
  
  project_open(.)
  ans(project)
  assign(project.project_descriptor.package_source = package_source)
  assign(!project.package_descriptor.hooks.on_unready = "'[]() map_append(${context} unready {{ARGN}})'")
  

  project_install(${project} A)

  project_dematerialize(${project} B)

  ## hook for B is not called because its content is already destroyed
  assertf("{context.unready[0].uri}" STREQUAL "project:root")
  assertf("{context.unready[1].uri}" STREQUAL "mock:A")
  assertf("{context.unready[2].uri}" STREQUAL "project:root")
  assertf("{context.unready[3].uri}" STREQUAL "project:root")


endfunction()