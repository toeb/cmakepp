## package_source_query_composite(<~uri> [--package-handle]) -> <uri..>|<pacakage handle...>
##
## --package-handle  flag specifiec that not a uri but a <package handle> should be returned
##
## queries the child sources (this.children) for the specified uri
## this is done by first rating and sorting the sources depending on 
## the uri so the best source is queryied first
## if a source returns a rating of 999 all other sources are disregarded
function(package_source_query_composite uri)
  arguments_extract_defined_values(0 ${ARGC} package_source_query_composite)
  uri_coerce(uri)

  log("querying for '{uri.uri}'")


  set(args ${ARGN})

  list_contains(args --package-handle)
  ans(return_package_handle)

  

  ## rate and sort sources for uri    
  this_get(children)
  map_values(${children})
  ans(children)

  rated_package_source_sort("${uri}" ${children})
  ans(rated_children)


  ## loop through every source and query it for uri
  ## append results to result. 
  ## if the rating is 0 break because all following sources will
  ## also be 0 and this indicates that the source is incompatible 
  ## with the uri
  ## if the rating is 999 break after querying the source as this 
  ## source has indicated that it is solely responsible for this uri
  set(result)
  while(true)
    if(NOT rated_children)
      break()
    endif()

    list_pop_front(rated_children)
    ans(current)

    map_tryget(${current} rating)
    ans(rating)
    ## source and all rest sources are incompatible 
    if(rating EQUAL 0)
      break()
    endif()




    map_tryget(${current} source)
    ans(source)
    log("querying package source '{source.source_name}' (rating: {rating})")
    ## query the source
    ## args (especially --package-handle will be passed along)
    assign(current_result = source.query("${uri}" ${args}))
    if(return_package_handle)
      foreach(handle ${current_result})
        map_tryget(${source} source_name)
        ans(source_name) 
        map_set(${handle} package_source_name ${source_name})
      endforeach()
    endif()
    ## append to result
    list(APPEND result ${current_result})
    ## source has indicated it is solely responsible for uri
    ## all further sources are disregarded
    if(NOT rating LESS  999)
      break()
    endif()
  endwhile()
  return_ref(result)
endfunction()

