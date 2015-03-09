function(test)

  pushd("pkg1" --create)
    fwrite_data("package.cmake" "{id:'mypkg',version:'0.0.0',content:'**'}" --json)
    fwrite(README.md "hello")
  popd()
  pushd("pkg2" --create)
    fwrite_data("package.cmake" "{id:'mypkg2',version:'0.0.0',content:'**'}" --json)
    fwrite(README.md "hello")
  popd()


  path_package_source()
  ans(path_source)

    
  ## create this object
  managed_package_source("mysource" "${test_dir}/packages")
  ans(this)
    

  package_source_push_managed(${path_source} "pkg1")
  package_source_push_managed(${path_source} "pkg2")

  assign(pkg1_uri = path_source.query("pkg1"))
  assign(pkg2_uri = path_source.query("pkg2"))


  package_source_pull_managed("?id=mypkg" pull1)
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/pull1/package.cmake")
  assertf({res.package_descriptor.id} STREQUAL "mypkg")


  package_source_pull_managed("?id=mypkg" pull2 --reference)
  ans(res)
  assert(res)
  assert(NOT EXISTS "${test_dir}/pull2")
  assertf({res.package_descriptor.id} STREQUAL "mypkg")
  

  package_source_pull_managed("")
  ans(res)
  assert(NOT res)


endfunction()