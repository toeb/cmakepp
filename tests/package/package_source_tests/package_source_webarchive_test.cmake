function(test)


  package_source_query_webarchive(
    "http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fjsoncpp%2F&ts=1422460575&use_mirror=switch" 
    --refresh
    --package-handle
    )

  ans(res)
  assertf({res.archive_descriptor.hash} STREQUAL "24482b67c1cb17aac1ed1814288a3a8f")
  assertf({res.query_uri} STREQUAL "http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fjsoncpp%2F&ts=1422460575&use_mirror=switch" )
  assertf({res.uri} STREQUAL "http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz?r=http://sourceforge.net/projects/jsoncpp/&ts=1422460575&use_mirror=switch&hash=24482b67c1cb17aac1ed1814288a3a8f" )
    
  package_source_resolve_webarchive(
    "http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fjsoncpp%2F&ts=1422460575&use_mirror=switch" 
    )

  ans(res)
  assertf({res.archive_descriptor.hash} STREQUAL "24482b67c1cb17aac1ed1814288a3a8f")
  assertf({res.query_uri} STREQUAL "http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fjsoncpp%2F&ts=1422460575&use_mirror=switch" )
  assertf({res.uri} STREQUAL "http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz?r=http://sourceforge.net/projects/jsoncpp/&ts=1422460575&use_mirror=switch&hash=24482b67c1cb17aac1ed1814288a3a8f" )
  assertf({res.package_descriptor.id} STREQUAL "jsoncpp-src")


  package_source_resolve_webarchive("https://github.com/toeb/cmakepp/archive/v0.0.3.tar.gz")
  ans(res)
  assertf({res.package_descriptor.id} STREQUAL "oo-cmake")
  assertf({res.package_descriptor.license} STREQUAL "MIT")
  assertf({res.archive_descriptor.package_descriptor_path} STREQUAL "cmakepp-0.0.3/package.cmake")




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


endfunction()