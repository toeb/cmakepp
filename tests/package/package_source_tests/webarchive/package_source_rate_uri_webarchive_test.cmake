function(test)

  
  package_source_rate_uri_webarchive("httpg://test.de/file")
  ans(res)
  assert(${res} EQUAL 0)
  

  package_source_rate_uri_webarchive("https://test.de/file.gz")
  ans(res)
  assert(${res} EQUAL 1000)

  package_source_rate_uri_webarchive("http://test.de/file.gz")
  ans(res)
  assert(${res} EQUAL 1000)


  package_source_rate_uri_webarchive("https://test.de/file")
  ans(res)
  assert(${res} EQUAL 50)
  
endfunction()
