
  function(composite_package_source source_name)
    set(sources ${ARGN})
    obj("{
      source_name:$source_name,
      query:'package_source_query_composite',
      resolve:'package_source_resolve_composite',
      pull:'package_source_pull_composite',
      add:'composite_package_source_add'
    }")
    ans(this)

    foreach(source ${sources})
      composite_package_source_add(${source})      
    endforeach()
    return_ref(this)
  endfunction()
