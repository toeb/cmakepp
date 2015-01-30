## returns the file type for the specified file
## only existing files can have a file type
## if an existing file does not have a specialized file type
## the extension is returned
function(mime_type file)
  path_qualify(file)
  if(NOT EXISTS "${file}")
    return(false)
  endif()
  if(IS_DIRECTORY "${file}")
    return(false)
  endif()



  file_istarfile("${file}")
  ans(is_tar)
  if(is_tar)
    return("application/x-gzip")
  endif()

  get_filename_component(extension "${file}" EXT)
  mime_type_from_extension("${extension}")

  return_ans()
endfunction()

function(mime_type_from_extension extension)

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
    return("application/x-cmake" "text.plain")
  endif()

  return()
endfunction()

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