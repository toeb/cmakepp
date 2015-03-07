function(test)
  map_new()
  ans(map)

  set(hook_callback "[](a b)map_append(${map} called {{a}} {{b}})")
  ## create a package with a dematerialize hook that registers
  fwrite_data("pkg1/package.cmake" "{cmakepp:{hooks:{on_dematerializing:$hook_callback}}}" --json)


  project_create(proj)
  ans(project)

  assign(project.remote = path_package_source())


  assign(installed_package = project.materialize("${test_dir}/pkg1"))
  assert(installed_package)
  assign(installed_package_uri = installed_package.uri)

  assign(success = project.dematerialize("${installed_package_uri}"))
  assert(success)


  assertf("{map.called[0]}" STREQUAL "${project}")
  assertf("{map.called[1].uri}" STREQUAL "{installed_package.uri}")



  ## create a package without a dematerialize hook 
  fwrite_data("pkg1/package.cmake" "{}" --json)

  project_create(proj --force)
  ans(project)

  assign(project.remote = path_package_source())


  assign(installed_package = project.materialize("${test_dir}/pkg1"))
  assign(installed_package_uri = installed_package.uri)
  assign(success = project.dematerialize("${installed_package_uri}"))
  assert(success)

  ## should run through without failing




endfunction()