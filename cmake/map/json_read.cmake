

  function(json_read file)
    if(NOT EXISTS "${file}")
      return()
    endif()
    checksum_file("${file}")
    ans(cache_key)
    file_cache_return_hit("${cache_key}")

    file(READ "${file}" data)
    json_deserialize("${data}")
    ans(data)

    file_cache_update("${cache_key}" "${data}")

    return_ref(data)
  endfunction()