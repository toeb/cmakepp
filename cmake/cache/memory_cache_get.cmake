

  function(memory_cache_get cache_key)
    memory_cache_key("${cache_key}")
    ans(key)
    map_tryget(memory_cache_entries "${key}")
    ans(value)
    map_clone_deep("${value}")
    return_ans()
  endfunction()


  