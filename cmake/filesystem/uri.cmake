
function(uri uri)
  map_isvalid(${uri})
  ans(ismap)
  if(ismap)
    return_ref(uri)
  endif()
  uri_parse("${uri}")
  ans(uri)
  return_ref(uri)
endfunction()

