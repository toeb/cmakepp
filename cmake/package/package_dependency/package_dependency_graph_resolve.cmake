## `(<package source> <package_handles:<package handle>...>  [--cache:<map>])->{ <<package uri>:<package handle>>...}`
##
## resolves the dependecy graphs given by `package_handles`
## returns a map of `<package uri> => <package handle>`
## uses the cache for to lookup `package uri`s
## the `package handle`s all habe a `dependees` and `dependencies` property
## see also `dependencies_resolve`
function(package_dependency_graph_resolve package_source)

  function(expand_dependencies package_source cache context package_handle)
    if(NOT package_handle)
      return()
    endif()
    map_tryget("${package_handle}" uri)
    ans(package_uri)

    #message(FORMAT "package_dependency_graph_resolve: expanding dependencies for ${package_uri}")
    map_has("${context}" "${package_uri}")
    ans(visited)
    if(visited)
      return()
    endif()

    map_set("${context}" "${package_uri}" ${package_handle})
    
    package_dependency_resolve("${package_source}"  "${package_handle}" --cache "${cache}")
    ## flatten the map twice -> results in package handles
    map_flatten(${__ans})
    map_flatten(${__ans})


    return_ans()
  endfunction()

  set(package_handles ${ARGN})
  list_extract_labelled_value(package_handles --cache)
  ans(cache)
  if(NOT cache)
    map_new()
    ans(cache)
  endif()

  ## add the root nodes of the graph into the cache
  foreach(package_handle ${package_handles})
    map_tryget(${package_handle} uri)
    ans(package_uri)
    map_set("${cache}" "${package_uri}" "${package_handle}")
  endforeach()


  ## create context
  map_new()
  ans(context)


  ## get a map of all dependencies mentioned in dependency graph
  curry3(() => expand_dependencies("${package_source}" "${cache}" "${context}" "/*"))
  ans(expand)
  dfs(${expand} ${package_handles})
  return_ref(context)
endfunction()

