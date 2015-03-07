## `(<package source> <package handle>  [--cache <map>] )-> { <<package uri>:<bool>>... }`
##  
##  returns a map of package_uris which consist of a valid dependecy configuration
##  { <package uri>:{ state: required|incompatible|optional}, package_handle{ dependencies: {packageuri: package handle} } }
##  or a reason why the configuration is impossible
## sideffects
##  
function(package_dependency_configuration package_source root_handle)
  set(args ${ARGN})
  ## get cache if available - else create a new one
  list_extract_labelled_value(args --cache)
  ans(cache)
  if(NOT cache)
    ## cache map 
    map_new()
    ans(cache)
  endif()


  map_tryget(${root_handle} uri)
  ans(root_uri)
  map_set("${cache}" "${root_uri}" "${root_handle}")

  ## returns a map of package_uri -> package_handle
  package_dependency_graph_resolve(${root_handle} --cache ${cache}) 
  ans(package_graph)
  
  ## creates a package configuration which can be rused to install / uninstall dependencies
  ## 
  package_dependency_graph_satisfy("${package_graph}" ${root_handle})
  return_ans()      
endfunction()