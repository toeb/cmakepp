function(test)

  



  mock_package_source(mock "A {cmake:{module:{include_dirs:'include',add_as_subdirectory:'true'}}}" B "A=>B")
  ans(package_source)

  project_open("")
  ans(project)
  assign(!project.project_descriptor.package_source = package_source)


  project_install(${project} A)


  assert(EXISTS "${test_dir}/cmake/FindA.cmake")
  fread(cmake/FindA.cmake)
  ans(dta)
  _message("${dta}")

endfunction()