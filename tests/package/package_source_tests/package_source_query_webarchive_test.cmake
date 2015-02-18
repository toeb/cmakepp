function(test)
  
  package_source_query_webarchive(
    "https://github.com/toeb/cmakepp/archive/v0.0.4.tar.gz"
    --refresh
    --package-handle
    )

  ans(res)
  assertf({res.archive_descriptor.hash} STREQUAL "a089a57c4ffd54725ff68faffb495847")
  assertf({res.query_uri} STREQUAL "https://github.com/toeb/cmakepp/archive/v0.0.4.tar.gz" )
  assertf({res.uri} STREQUAL "https://github.com/toeb/cmakepp/archive/v0.0.4.tar.gz?hash=a089a57c4ffd54725ff68faffb495847" )
    

  package_source_query_webarchive("https://github.com/toeb/cmakepp/archive/v0.0.4.tar.gz?hash=a089a57c4ffd54725ff68faffb495847")
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