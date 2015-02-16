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


  mime_type_from_file_content("${file}")
  ans(mime_type)

  if(mime_type)
    return_ref(mime_type)
  endif()

  mime_type_from_filename("${file}")

  return_ans()
endfunction()


function(mime_type_from_file_content file)
  path_qualify(file)
  if(NOT EXISTS "${file}")

  endif()

  file_istarfile("${file}")
  ans(is_tar)
  if(is_tar)
    return("application/x-gzip")
  endif()


  file_isqmfile("${file}")
  ans(is_qm)
  if(is_qm)
    return("application/x-quickmap")
  endif()

  return()
endfunction()

function(file_isqmfile file)
    path_qualify(file)
    if(NOT EXISTS "${file}" OR IS_DIRECTORY "${file}")
      return(false)
    endif()
  file(READ "${file}" result LIMIT 3)
  if(result STREQUAL "#qm")
    return(true)
  endif()

  return(false)

endfunction()