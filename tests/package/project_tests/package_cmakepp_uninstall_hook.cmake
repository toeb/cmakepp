function(test)
  map_new()
  ans(map)

  set(hook_callback "(a b)->map_append(${map} called $a $b)")
  ## create a package with an uninstall hook that registers
  fwrite_data("pkg1/package.cmake" "{cmakepp:{hooks:{on_uninstall:$hook_callback}}}" --json)


  project_create(proj)
  ans(project)

  assign(project.remote = path_package_source())


  assign(installed_package_uri = project.install("${test_dir}/pkg1"))
  assert(installed_package_uri)

  assign(success = project.uninstall("${installed_package_uri}"))
  assert(success)


  assertf("{map.called[0]}" STREQUAL "${project}")
  assertf("{map.called[1].uri}" STREQUAL "${installed_package_uri}")



  ## create a package with an uninstall hook that registers
  fwrite_data("pkg1/package.cmake" "{}" --json)

  project_create(proj --force)
  ans(project)

  assign(project.remote = path_package_source())


  assign(installed_package_uri = project.install("${test_dir}/pkg1"))
  assert(installed_package_uri)

  assign(success = project.uninstall("${installed_package_uri}"))
  assert(success)

  ## should run through without failing




endfunction()