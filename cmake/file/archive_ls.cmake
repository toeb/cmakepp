function(archive_ls archive)
  path_qualify(archive)


  mime_type("${archive}")
  ans(types)


  if("${types}" MATCHES "application/x-gzip")
    tar(tf "${archive}")
    ans(files)

    tar(tf "${archive}" --result)
    ans(result)

    assign(error = result.error)
    if(error)
      error("tar exited with {result.error}")
      return()
    endif()

    assign(files = result.stdout)

    string(REGEX MATCHALL "(^|\n)([^\n]+)(\n|$)" files "${files}")
    string(REGEX REPLACE "(\r|\n)" "" files "${files}")
    return_ref(files)

  else()
    message(FATAL_ERROR "${archive} unsupported compression: '${types}'")
  endif()

 endfunction()
