## returns an info object for the specified svn url
## {
##    path:"path",
##    revision:"revision",
##    kind:"kind",
##    url:"url",
##    root:"root",
##    uuid:"uuid",
## }
## todo: cached?
function(svn_info)
    svn_uri("${ARGN}")
    ans(uri)

    svn(info ${uri} --result --xml)
    ans(res)
    map_tryget(${res} result)
    ans(error)
    if(error)
      return()
    endif()

    map_tryget(${res} output)
    ans(xml)

    xml_parse_attrs("${xml}" entry path)    
    ans(path)
    xml_parse_attrs("${xml}" entry revision)    
    ans(revision)
    xml_parse_attrs("${xml}" entry kind)    
    ans(kind)
    xml_parse_values("${xml}" url)
    ans(url)
    xml_parse_values("${xml}" root)
    ans(root)

    xml_parse_values("${xml}" uuid)
    ans(uuid)
    map()
      var(path revision kind url root uuid)
    end()
    ans(res)
    return_ref(res)
endfunction()