function(test)



  uri_parse("")
  ans(res)

  assertf("{res.scheme}" ISNULL)
  assertf("{res.net_root}" ISNULL)
  assertf("{res.abs_root}" ISNULL)
  assertf("{res.segments}" ISNULL)

  uri_parse(".")
  ans(res)
  assertf("{res.scheme}" ISNULL)
  assertf("{res.net_root}" ISNULL)
  assertf("{res.abs_root}" ISNULL)
  assertf("{res.segments}" "." ARE_EQUAL)
  
  uri_parse("..")
  ans(res)
  assertf("{res.scheme}" ISNULL)
  assertf("{res.net_root}" ISNULL)
  assertf("{res.abs_root}" ISNULL)
  assertf("{res.segments}" ".." ARE_EQUAL)
  
  
  uri_parse("/")
  ans(res)
  assertf("{res.scheme}" ISNULL)
  assertf("{res.net_root}" ISNULL)
  assertf("{res.abs_root}" "/" ARE_EQUAL)
  assertf("{res.segments}" ISNULL)
  
  
  uri_parse("../")
  ans(res)
  assertf("{res.scheme}" ISNULL)
  assertf("{res.net_root}" ISNULL)
  assertf("{res.abs_root}" ISNULL)
  assertf("{res.segments}" ".." ARE_EQUAL)


  uri_parse("./")
  ans(res)
  assertf("{res.scheme}" ISNULL)
  assertf("{res.net_root}" ISNULL)
  assertf("{res.abs_root}" ISNULL)
  assertf("{res.segments}" "." ARE_EQUAL)

  uri_parse("~/")
  ans(res)
  assertf("{res.scheme}" ISNULL)
  assertf("{res.net_root}" ISNULL)
  assertf("{res.abs_root}" ISNULL)
  assertf("{res.segments}" "~" ARE_EQUAL)
  
  uri_parse("c:\\test\\directory")
  ans(res)
  
  assertf("{res.scheme}" c ARE_EQUAL)
  assertf("{res.net_root}" ISNULL)
  assertf("{res.abs_root}" / ARE_EQUAL)
  assertf("{res.segments}" test directory ARE_EQUAL)

  uri_parse("\\\\TOBI-PC\\Share1\\asd.txt")
  ans(res)
  assertf("{res.authority}" "TOBI-PC" ARE_EQUAL)
  assertf("{res.net_root}" ISNOTNULL)
  assertf("{res.abs_root}" ISNULL)
  assertf("{res.segments}" Share1 asd.txt ARE_EQUAL)
  assertf("{res.extension}" txt ARE_EQUAL)
  assertf("{res.file}" asd.txt ARE_EQUAL)
  assertf("{res.file_name}" asd ARE_EQUAL)



  uri_parse("c:/test/directory")
  ans(res)
  
  uri_parse("http://www.google.de/service/index.html?abc=unglaublich&def=unbelievable")
  ans(res)
  assertf("{res.scheme}" "http" ARE_EQUAL)
  assertf("{res.authority}" "www.google.de" ARE_EQUAL)
  assertf("{res.net_root}" ISNOTNULL)
  assertf("{res.abs_root}" ISNULL)
  assertf("{res.segments}" service index.html ARE_EQUAL)
  assertf("{res.extension}" html ARE_EQUAL)
  assertf("{res.file}" index.html ARE_EQUAL)
  assertf("{res.file_name}" index ARE_EQUAL)
  assertf("{res.fragment}" ISNULL)
  assertf("{res.query}" "abc=unglaublich&def=unbelievable" ARE_EQUAL)

  
  uri_parse("scheme1+scheme2://www.welt.de/article2014-1-2/title/view.xml?id=asdasd#nananan")
  ans(res)
  assertf("{res.scheme}" "scheme1+scheme2" ARE_EQUAL)
  assertf("{res.authority}" "www.welt.de" ARE_EQUAL)
  assertf("{res.net_root}" ISNOTNULL)
  assertf("{res.abs_root}" ISNULL)
  assertf("{res.segments}" "article2014-1-2" title view.xml ARE_EQUAL)
  assertf("{res.extension}" xml ARE_EQUAL)
  assertf("{res.file}" view.xml ARE_EQUAL)
  assertf("{res.file_name}" view ARE_EQUAL)
  assertf("{res.query}" id=asdasd ARE_EQUAL)
  assertf("{res.fragment}" nananan ARE_EQUAL)




  uri_parse("'scheme1+scheme2://tobi:password@192.168.0.1:23/path/to/nix' aoidjaosjdasd")
  ans(res)

  assertf("{res.scheme}" "scheme1+scheme2" ARE_EQUAL)
  assertf("{res.authority}" "tobi:password@192.168.0.1:23" ARE_EQUAL)
  assertf("{res.net_root}" ISNOTNULL)
  assertf("{res.abs_root}" ISNULL)
  assertf("{res.segments}" path to nix  ARE_EQUAL)
  assertf("{res.file}" nix ARE_EQUAL)
  assertf("{res.file_name}" nix ARE_EQUAL)
  assertf("{res.query}"  ISNULL)
  assertf("{res.fragment}"  ISNULL)
  assertf("{res.rest}" " aoidjaosjdasd" ARE_EQUAL)
  
  # check that spaces in segments are treate correctly
  uri_parse("'c:\\asd b\\herge 323/test test.txt'")
  ans(res)
  assertf("{res.segments}" "asd%20b" "herge%20323" "test%20test.txt" ARE_EQUAL)
  json_print(${res})

endfunction()