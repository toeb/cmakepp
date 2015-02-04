
  function(composite_package_source source_name)
    set(sources ${ARGN})
    obj("{
      source_name:$source_name,
      children:$sources,
      query:'package_source_query_composite',
      resolve:'package_source_resolve_composite',
      pull:'package_source_pull_composite',
      add:'composite_package_source_add'
    }")
    return_ans()
  endfunction()
