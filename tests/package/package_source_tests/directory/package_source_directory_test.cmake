function(test)
  



  pushd(packages --create)
    fwrite_data("pkg1/package.cmake" "{id:'mypkg1',version:'0.0.0'}" --json)
    fwrite_data("pkg2/package.cmake" "{id:'mypkg2',version:'0.0.0'}" --json)
    fwrite_data("pkg3/package.cmake" "{id:'mypkg3',version:'0.0.0'}" --json)
    fwrite_data("pkg4/README.md" "hello")
  popd()


  map_new()
  ans(this)
  map_set(${this} directory "${test_dir}/packages")
  map_set(${this} source_name "mysource")




  package_source_query_directory("mysource:pkg1" --package-handle)
  ans(res)
  assertf({res.uri} STREQUAL "mysource:pkg1")
  assertf({res.query_uri} STREQUAL "mysource:pkg1")


  package_source_query_directory("")
  ans(res)
  assert(NOT res)

  package_source_query_directory("?*")
  ans(res)
  assert(${res} CONTAINS "mysource:pkg1")
  assert(${res} CONTAINS "mysource:pkg2")
  assert(${res} CONTAINS "mysource:pkg3")
  assert(${res} CONTAINS "mysource:pkg4")


  package_source_query_directory("pkg1")
  ans(res)
  assert(res)
  assert(res STREQUAL "mysource:pkg1")

  package_source_query_directory("othersource:pkg1")
  ans(res)
  assert(NOT res)



  uri("mysource:pkg1")
  ans(uri)
  package_source_resolve_directory("${uri}")
  ans(res)
  assert(res)

  package_source_pull_directory("")
  ans(res)
  assert(NOT res)

  package_source_pull_directory("pkg1" pull1)
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "mypkg1")
  assertf("{res.content_dir}" STREQUAL "${test_dir}/pull1")
  assertf("{res.uri}" STREQUAL "mysource:pkg1")
  assert(EXISTS "${test_dir}/pull1/package.cmake")




  package_source_resolve_directory("")
  ans(res)
  assert(NOT res)

  package_source_resolve_directory("?*")
  ans(res)
  assert(NOT res)

  package_source_resolve_directory("pkg1")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "mypkg1")
  assertf("{res.package_descriptor.version}" STREQUAL "0.0.0")
  assertf("{res.content_dir}" STREQUAL "${test_dir}/packages/pkg1")
  assertf("{res.uri}" STREQUAL "mysource:pkg1")







endfunction()