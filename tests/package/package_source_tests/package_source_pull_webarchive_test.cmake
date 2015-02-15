function(test)


  package_source_pull_webarchive(
    "https://github.com/toeb/cmakepp/archive/v0.0.5.tar.gz"
    --refresh
    "pull/p1")
  ans(res)
  log_last_error_print()
  assert(res)
  assertf({res.package_descriptor.id} STREQUAL "cmakepp")
  assertf({res.package_descriptor.license} STREQUAL "MIT")
  assertf({res.archive_descriptor.package_descriptor_path} STREQUAL "cmakepp-0.0.5/package.cmake")
  assert(EXISTS "${test_dir}/pull/p1")



  return()
  ## uri does not work
  package_source_pull_webarchive(
    "http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fjsoncpp%2F&ts=1422460575&use_mirror=switch" 
    --refresh
    "pull/p1"
  )
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "jsoncpp-src")
  assertf("{res.content_dir}" STREQUAL "${test_dir}/pull/p1")
  assertf("{res.uri}" MATCHES "http://downloads.sourceforge.net")
  assert(EXISTS "${test_dir}/pull/p1")


endfunction()