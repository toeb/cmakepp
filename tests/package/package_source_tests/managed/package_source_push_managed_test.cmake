function(test)

  pushd("pkg1" --create)
    fwrite_data("package.cmake" "{id:'mypkg',version:'0.0.0',include:'**'}" --mime-type application/json)
    fwrite(README.md "hello")
  popd()
  pushd("pkg2" --create)
    fwrite_data("package.cmake" "{id:'mypkg2',version:'0.0.0',include:'**'}" --mime-type application/json)
    fwrite(README.md "hello")
  popd()

  pushd("pkg3" --create)
    fwrite_data("package.cmake" "{id:'mypkg3',version:'0.0.0',include:'**'}" --mime-type application/json)
    fwrite(README.md "hello")
  popd()


  path_package_source()
  ans(path_source)
    
  ## create this object
  map_new()
  ans(this)
  map_set(${this} directory "${test_dir}/packages")
  map_set(${this} source_name "mysource")


timer_start(push_package)
  package_source_push_managed(${path_source} "pkg1")
  ans(res)
  timer_print_elapsed(push_package)
  assert(res) 
  assertf("{res.managed_descriptor.remote_source_name}" STREQUAL "file")
  assertf("{res.package_descriptor.id}" STREQUAL "mypkg")

  package_source_push_managed(${path_source} "asdasdasd")
  ans(res)
  assert(NOT res)



package_source_push_managed(${path_source} "pkg3" --package-dir "_pkgs")
ans(res)
assert(res)
assert(EXISTS "${test_dir}/_pkgs/mypkg3")
assertf({res.content_dir} STREQUAL "${test_dir}/_pkgs/mypkg3")





endfunction()