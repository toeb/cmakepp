function(test)


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