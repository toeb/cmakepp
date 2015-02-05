function(test)

  pushd("pkg1" --create)
    fwrite_data("package.cmake" "{id:'mypkg',version:'0.0.0',include:'**'}" --mime-type application/json)
    fwrite(README.md "hello")
  popd()
  pushd("pkg2" --create)
    fwrite_data("package.cmake" "{id:'mypkg2',version:'0.0.0',include:'**'}" --mime-type application/json)
    fwrite(README.md "hello")
  popd()



  ## create this object
  map_new()
  ans(this)
  map_set(${this} directory "${test_dir}/packages")
  map_set(${this} source_name "mysource")

    

  package_source_push_managed("pkg1")
  ans(res)
  assert(res)
  assert("${res}" MATCHES "mysource:.*mypkg.*")
  string(REPLACE "mysource:" "" res "${res}")
  assert(EXISTS "${test_dir}/packages/${res}")


  package_source_push_managed("pkg2")

  package_source_query_managed("?*")
  ans(res)
  assert(res)
  assert(${res} CONTAINS "mysource:mypkg_0_0_0")
  assert(${res} CONTAINS "mysource:mypkg2_0_0_0")

  package_source_query_managed("")
  ans(res)
  assert(NOT res)

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

  package_source_resolve_managed("")
  ans(res)
  assert(NOT res)

  package_source_resolve_managed("?/mypkg/")
  ans(res)
  assert(NOT res)

  package_source_resolve_managed("mypkg_0_0_0")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "mypkg")
  assertf("{res.content_dir}" MATCHES "${test_dir}/packages")
  assertf("{res.uri}" STREQUAL "mysource:mypkg_0_0_0")


  package_source_pull_managed("mypkg_0_0_0" pull1)
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/pull1/package.cmake")
  assertf({res.package_descriptor.id} STREQUAL "mypkg")


  package_source_pull_managed("mypkg_0_0_0" pull2 --reference)
  ans(res)
  assert(res)
  assert(NOT EXISTS "${test_dir}/pull2")
  assertf({res.package_descriptor.id} STREQUAL "mypkg")
  assertf({res.content_dir} STREQUAL "${test_dir}/packages/mypkg_0_0_0/content")

  package_source_pull_managed("")
  ans(res)
  assert(NOT res)


endfunction()