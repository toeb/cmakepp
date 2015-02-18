
function(archive_ls archive)
  path_qualify(archive)


  mime_type("${archive}")
  ans(types)


  if("${types}" MATCHES "application/x-gzip")
    checksum_file("${archive}")
    ans(key)
    string_cache_return_hit(archive_ls_cache "${key}")


    tar(tf "${archive}")
    ans(files)

    tar(tf "${archive}" --process-handle)
    ans(result)

    assign(error = result.exit_code)
    if(error)
      error("tar exited with {result.error}")
      return()
    endif()

    assign(files = result.stdout)

    string(REGEX MATCHALL "(^|\n)([^\n]+)(\n|$)" files "${files}")
    string(REGEX REPLACE "(\r|\n)" "" files "${files}")
    
    string_cache_update(archive_ls_cache "${key}" "${files}")
    return_ref(files)

  else()
    message(FATAL_ERROR "${archive} unsupported compression: '${types}'")
  endif()

 endfunction()
