## `(<cache:<map>> <package handle>...)->{ <<package uri>:<package handle>>...}`
##
## resolves the dependecy graphs given by `package_handles`
## returns a map of `<package uri> => <package handle>`
## uses the cache for to lookup `package uri`s
## the `package handle`s all habe a `dependees` and `dependencies` property
## see also `dependencies_resolve`
function(package_dependency_graph_resolve cache)
  set(package_handles ${ARGN})
  map_new()
  ans(context)
  function(expand_dependencies package_source cache context package_handle)
    map_tryget("${package_handle}" uri)
    ans(package_uri)
    #message(FORMAT "expanding dependencies for {package_handle.package_descriptor.id}")
    map_has("${context}" "${package_uri}")
    ans(visited)
    if(visited)
    #  message(FORMAT "  already visited")
      return()
    endif()

    map_set("${context}" "${package_uri}" ${package_handle})

    package_dependency_resolve("${package_source}" "${cache}" "${package_handle}")
    ans(dependency_handles)
    map_values(${dependency_handles})
    ans(dependency_handles)
    return_ref(dependency_handles)
  endfunction()

  ## get a map of all dependencies mentioned in dependency graph
  curry3(() => expand_dependencies("${package_source}" "${cache}" "${context}" "/*"))
  ans(expand)
  dfs(${expand} ${package_handles})
  return_ref(context)
endfunction()
