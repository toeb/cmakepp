
  ## downloadsa the specified url and stores it in target file
  ## if specified
  ## --refresh causes the cache to be updated
  ## --readonly allows optimization if the result is not modified
  function(download_cached uri)
    set(args ${ARGN})
    list_extract_flag(args --refresh)
    ans(refresh)
    list_extract_flag(args --readonly)
    ans(readonly)
    
    oocmake_config(temp_dir)
    ans(temp_dir)

    string(MD5 cache_key "${uri}")
    set(cached_path "${temp_dir}/download_cache/${cache_key}")
   
    if(EXISTS "${cached_path}" AND NOT refresh)
      if(readonly)
        file_glob("${cached_path}" "**")
        ans(file_path)
        if(NOT EXISTS "${file_path}")
          message(FATAL_ERROR "expected a file to exist in cached dir for ${uri}")
        endif()
        return_ref(file_path)
      else()
        message(FATAL_ERROR "not supported")
      endif()
    endif()

    mkdir("${cached_path}")
    download("${uri}" "${cached_path}" ${args})
    ans(res)
    if(NOT res)
      rm("${cached_path}")
    endif()
    return_ref(res)
  endfunction()
