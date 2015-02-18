## tries to read the spcified file format
function(fread_data path)
  set(args ${ARGN})


  path_qualify(path)
  
  list_pop_front(args)
  ans(mime_type)

  if(NOT mime_type)

    mime_type("${path}")
    ans(mime_type)

    if(NOT mime_type)
      return()
    endif()

  endif()


  if("${mime_type}" MATCHES "application/json")
    json_read("${path}")
    return_ans()
  elseif("${mime_type}" MATCHES "application/x-quickmap")
    qm_read("${path}")
    return_ans()
  else()
    return()
  endif()

endfunction()
