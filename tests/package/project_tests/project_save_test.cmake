function(test)

  project_new()
  ans(project)

  events_track(project_on_installed_package_save project_on_installed_packages_save on_package_save)
  ans(tracker)


  call(project.load("pr1"))


  ### save in default location

  ## act
  assign(success = project.save())

  assert(success)
  assert(EXISTS "${test_dir}/pr1/.cps/config.qm")
  assert(EXISTS "${test_dir}/pr1/.cps/package_descriptor.qm")
  fread_data("pr1/.cps/config.qm")
  ans(res)

  assertf({res.config_dir} STREQUAL ".cps")
  assertf({res.dependency_dir} STREQUAL "packages")
  assertf({res.content_dir} STREQUAL ".")
  assertf({res.config_file} STREQUAL ".cps/config.qm")
  assertf({res.package_descriptor_file} STREQUAL ".cps/package_descriptor.qm")


  ### save in custom location

  ## act
  assign(success = project.save("myfile.qm"))

  assert(success)
  assert(EXISTS "${test_dir}/myfile.qm")


  assertf("{tracker.project_on_installed_package_save[0].args[0]}" STREQUAL "${project}")
  assertf("{tracker.project_on_installed_package_save[0].args[1]}" STREQUAL "${project}")

endfunction()