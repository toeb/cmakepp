## package_source_query_composite(<~uri> [--package-handle]) -> <uri..>|<pacakage handle...>
##
## --package-handle  flag specifiec that not a uri but a <package handle> should be returned
##
## queries the child sources (this.children) for the specified uri
## this is done by first rating and sorting the sources depending on 
## the uri so the best source is queryied first
## if a source returns a rating of 999 all other sources are disregarded
  function(package_source_query_composite uri)
    uri("${uri}")
    ans(uri)

    set(args ${ARGN})

    list_contains(args --package-handle)
    ans(return_package_handle)

    

    ## rate and sort sources for uri    
    this_get(children)
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

      ## query the source
      ## args (especially --package-handle will be passed along)
      assign(current_result = source.query("${uri}" ${args}))

      if(return_package_handle)
        map_set(${current_result} package_source ${source})
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

  ## sorts the rated package sources by rating
  ## and returns them
  function(rated_package_source_sort uri)
    rated_package_sources(${ARGN})
    ans(rated_sources)


    list_sort(rated_sources rated_package_source_compare)
    ans(rated_sources)
    return_ref(rated_sources)
  endfunction()

  ## compares two rated package sources and returns a number
  ## pointing to the lower side
  function(rated_package_source_compare lhs rhs)
      map_tryget(${rhs} rating)
      ans(rhs)
      map_tryget(${lhs} rating)
      ans(lhs)
      math(EXPR result "${lhs} - ${rhs}")
      return_ref(result)
  endfunction()

  ## function used to rate a package source and a a uri
  ## default rating is 1 
  ## if a scheme of uri matches the source_name property
  ## of a package source the rating is 999
  ## else package_source's rate_uri function is called
  ## if it exists which can return a custom rating
  function(package_source_rate_uri package_source uri)
    uri("${uri}")
    ans(uri)

    set(rating 1)

    map_tryget(${uri} schemes)
    ans(schemes)
    map_tryget(${package_source} source_name)
    ans(source_name)

    ## contains scheme -> rating 999
    list_contains(schemes "${source_name}")
    ans(contains_scheme)

    if(contains_scheme)
      set(rating 999)
    endif()

    ## package source may override default behaviour
    map_tryget(${package_source} rate_uri)
    ans(rate_uri)
    if(rate_uri)
      call(source.rate_uri(${uri}))
      ans(rating)
    endif()

    return_ref(rating)
  endfunction()