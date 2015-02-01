

function(mime_type_get_extension mime_type)
  if(mime_type STREQUAL "application/cmake")
    return("cmake")
  elseif(mime_type STREQUAL "application/json")
    return("json")
  elseif(mime_type STREQUAL "application/x-quickmap")
    return("qm")
  elseif(mime_type STREQUAL "application/x-gzip")
    return("tgz")
  elseif(mime_type STREQUAL "text/plain")
    return("txt")
  endif()

  return()
endfunction()