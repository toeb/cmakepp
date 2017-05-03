## package_source_resolve_composite(<~uri>) -> <package handle>
## returns the package handle for the speciified uri
## the handle's package_source property will point to the package source used
parameter_definition(package_source_resolve_composite
  <uri{"the query uri"}:<uri>> 
  )
function(package_source_resolve_composite)
  arguments_extract_defined_values(0 ${ARGC} package_source_resolve_composite)
  ans(args)  
  

  #message(FORMAT "package_source_resolve_composite: {uri.uri}")
  uri_coerce(uri)

  ## query composite returns the best matching package_uris first
  ## specifiying --package-handle returns the package handle as 
  ## containing the package_uri and the package_source
  package_source_query_composite("${uri}" --package-handle)
  ans(package_handles)

  ## loops through every package handle and tries to resolve
  ## it. returns the handle on the first success
  while(true)

    if(NOT package_handles)
      return()
    endif()

    list_pop_front(package_handles)
    ans(package_handle)
    
    map_tryget(${package_handle} package_source_name)
    ans(package_source_name)

    assign(package_source = "this.children.${package_source_name}")
    
    if(NOT package_source)
      message(FATAL_ERROR "package handle missing package_source property")
    endif()
    #map_tryget(${package_handle} uri)
    #ans(uri)  removed so that the original uri can stay same
    # and because of the small time daly between query and resolve
    # the uri will be stable enough

    assign(package_handle = package_source.resolve("${uri}"))

    if(package_handle)        
      ## copy over package source to new package handle
      assign(package_handle.package_source_name = package_source_name)
     # assign(package_handle.rating = source_uri.rating)
      return_ref(package_handle)
    endif()

  endwhile()
  return()
endfunction() 

