
  ## creates rated package sources from the specified sources
  ## { rating:<number>, source:<package source>}
  function(rated_package_sources)
    set(result)
    foreach(source ${ARGN})
      map_new() 
      ans(map)
      map_set(${map} source ${source})
      package_source_rate_uri(${source} ${uri})
      ans(rating)
      map_set(${map} rating ${rating}) 
      list(APPEND result ${map})
    endforeach()
    return_ref(result)
  endfunction()
