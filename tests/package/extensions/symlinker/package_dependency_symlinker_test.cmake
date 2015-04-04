function(test)

  

  mock_package_source("mock" A B "A=>B")
  ans(package_source)

  project_open("")
  ans(project)
  assign(project.project_descriptor.package_source = package_source)

  project_install(${project} "A {symlink:'pkg1'}")



  assert(EXISTS "${test_dir}/pkg1")
  fwrite(pkg1/hello.txt "hello")
  assert(EXISTS "${test_dir}/packages/mock_A-0.0.0/hello.txt")



  project_dematerialize(${project} "B")

  ## cehck that lnk is removed but data stays intact
  assert(NOT EXISTS "${test_dir}/pkg1")
  assert(EXISTS "${test_dir}/packages/mock_A-0.0.0/hello.txt")

endfunction()