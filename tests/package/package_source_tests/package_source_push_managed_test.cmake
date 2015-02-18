function(test)

  pushd("pkg1" --create)
    fwrite_data("package.cmake" "{id:'mypkg',version:'0.0.0',include:'**'}" --mime-type application/json)
    fwrite(README.md "hello")
  popd()
  pushd("pkg2" --create)
    fwrite_data("package.cmake" "{id:'mypkg2',version:'0.0.0',include:'**'}" --mime-type application/json)
    fwrite(README.md "hello")
  popd()


  path_package_source()
  ans(path_source)
    
  ## create this object
  map_new()
  ans(this)
  map_set(${this} directory "${test_dir}/packages")
  map_set(${this} source_name "mysource")



  package_source_push_managed(${path_source} "pkg1")
  ans(res)
  assert(res) 
  assertf("{res.managed_descriptor.source_name}" STREQUAL "mysource")
  assertf("{res.package_descriptor.id}" STREQUAL "mypkg")

  package_source_push_managed(${path_source} "asdasdasd")
  ans(res)
  assert(NOT res)

return()  
  assert("${res}" MATCHES "mysource:.*mypkg.*")
  string(REPLACE "mysource:" "" res "${res}")
  assert(EXISTS "${test_dir}/packages/${res}")


  package_source_push_managed("pkg2")


endfunction()