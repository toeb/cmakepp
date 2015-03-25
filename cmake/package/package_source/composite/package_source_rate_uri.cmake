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