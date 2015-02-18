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

  assign(pkg1_uri = path_source.query("pkg1"))
  assign(pkg2_uri = path_source.query("pkg2"))
    
  ## create this object
  managed_package_source("mysource" "${test_dir}/packages")
  ans(this)

  package_source_push_managed(${path_source} "pkg1")
  package_source_push_managed(${path_source} "pkg2")


  package_source_query_managed("?*")
  ans(res)
  
  assert(res)
  assert(${res} MATCH "file.*pkg1")
  assert(${res} MATCH "file.*pkg2")

  package_source_query_managed("")
  ans(res)
  assert(NOT res)

  package_source_query_managed("?id=mypkg")
  ans(res)
  assert(res)
  assert(${res} MATCHES "file.*pkg1")


  package_source_query_managed("${pkg1_uri}")
  ans(res)
  assert("${res}" STREQUAL "${pkg1_uri}")

return()
  package_source_query_managed("mypkg_0_0_0")
  ans(res)
  assert(res)
  assert(res STREQUAL "mysource:mypkg_0_0_0")

  package_source_query_managed("?/mypk.*/")
  ans(res)
  assert(res)
  assert(${res} CONTAINS "mysource:mypkg_0_0_0")
  assert(${res} CONTAINS "mysource:mypkg2_0_0_0")


  package_source_query_managed("?/.*2/")
  ans(res)
  assert(res)
  assert(res STREQUAL "mysource:mypkg2_0_0_0")


endfunction()