

  function(memory_cache_update cache_key value)

    map_clone_deep("${value}")
    ans(value)
    memory_cache_key("${cache_key}")
    ans(key)
    #map_new()
    #ans(entry)
    #map_set_hidden(${entry} data ${value})
    #map_set_hidden(${entry} key ${key})
    #map_set_hidden(${entry} const ${_const})
    map_set_hidden(memory_cache_entries "${key}" "${value}")
  endfunction()