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



  package_source_resolve_managed("")
  ans(res)
  assert(NOT res)

  package_source_resolve_managed("?id=mypkg")
  ans(res)
  assert(res)

  package_source_resolve_managed("${pkg1_uri}")
  ans(res)
  assert(res)
  assertf("{res.uri}" MATCHES "pkg1")



  package_source_resolve_managed("?id=mypkg")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "mypkg")
  assertf("{res.content_dir}" MATCHES "${test_dir}/packages")


endfunction()