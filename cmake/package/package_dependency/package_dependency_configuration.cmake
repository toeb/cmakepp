## `(<package source> <package handle>  [--cache <map>] )-> <dependency configuration>`
##  
## the `<dependency configuration> ::= { <<dependable uri>:<bool>>... }`
## is a map which indicates which dependencies MUST BE present and which MAY NOT
##
##  returns a map of `package uri`s which consist of a valid dependency configuration
##  { <package uri>:{ state: required|incompatible|optional}, package_handle{ dependencies: {packageuri: package handle} } }
##  or a reason why the configuration is impossible
##
##  **sideffects**
## *sets the `dependencies` property of all `package handle`s to the configured dependency using `package_dependency_configuration_set`.
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
  
  ## creates a package configuration which can be rused to install / uninstall 
  ## dependencies
  package_dependency_graph_satisfy("${package_graph}" ${root_handle})
  ans(configuration)

  if(configuration)  
    map_values(${package_graph})
    ans(package_handles)
    package_dependency_configuration_set(${configuration} ${package_handles})
  endif()

  return_ref(configuration)
endfunction()
