

  function(uri_remove_schemes uri)
    uri("${uri}")
    ans(uri)
    map_tryget(${uri} schemes)
    ans(schemes)
    list_remove(schemes ${ARGN})
    map_set(${uri} schemes)
    list_combine("+" ${schemes})
    ans(scheme)
    map_tryget(${uri} scheme)
    return_ref(uri)
  endfunction()