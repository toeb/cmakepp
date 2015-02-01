

function(mime_type_from_extension extension)
  if("${extension}" MATCHES "\\.(.*)")
    set(extension "${CMAKE_MATCH_1}")
  endif()

  if("${extension}" MATCHES "tgz|tar\\.gz|gz")
    return("application/x-gzip")
  endif()

  if(extension STREQUAL "zip")
    return("application/zip")
  endif()

  if(extension STREQUAL "7z")
    return("application/x-7z-compressed")
  endif()

  if(extension STREQUAL "txt" OR extension STREQUAL "asc")
    return("text/plain")
  endif()

  if(extension STREQUAL "json")
      return("application/json")
  endif()

  if(extension STREQUAL "qm")
    return("application/x-quickmap" "text/plain")
  endif()

  if(extension STREQUAL "cmake")
    return("application/x-cmake" "text/plain")
  endif()

  return()
endfunction()