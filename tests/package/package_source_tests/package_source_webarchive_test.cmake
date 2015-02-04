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




  package_source_resolve_webarchive("http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fjsoncpp%2F&ts=1422460575&use_mirror=switch" --refresh)
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.id}" STREQUAL "jsoncpp-src")
  assertf("{res.uri}" MATCHES "http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz")
  

#
  package_source_query_webarchive("http://downloads.sourceforge.net/project/tinyxml/tinyxml/2.6.2/tinyxml_2_6_2.zip?r=&ts=1422459261&use_mirror=switch" --refresh)
  ans(res)
  assert(res)


  package_source_query_webarchive("http://illegal.host/file")
  ans(res)
  assert(NOT res)

  package_source_query_webarchive("http://github.com/lloyd/yajl/tarball/2.1.0" --refresh)
  ans(res)
  assert(res)


  ## chached download
  package_source_query_webarchive("http://github.com/lloyd/yajl/tarball/2.1.0")
  ans(res)
  assert(res)


return()



endfunction()