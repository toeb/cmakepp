
  ## sorts the rated package sources by rating
  ## and returns them
  function(rated_package_source_sort uri)
    rated_package_sources(${ARGN})
    ans(rated_sources)


    list_sort(rated_sources rated_package_source_compare)
    ans(rated_sources)
    return_ref(rated_sources)
  endfunction()
