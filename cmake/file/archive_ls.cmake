function(archive_ls archive)
  path_qualify(archive)


  mime_type("${archive}")
  ans(types)


  if("${types}" MATCHES "application/x-gzip")
    tar(tf "${archive}")
    ans(res)

    string(REGEX REPLACE "(\r\n)|(\n)" ";" res "${res}")
    return_ref(res)

  else()
    message(FATAL_ERROR "${archive} unsupported compression: '${types}'")
  endif()

 endfunction()
