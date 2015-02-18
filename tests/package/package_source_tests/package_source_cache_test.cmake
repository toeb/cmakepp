function(test)




  function(cached_package_source inner)
    set(args ${ARGN})
    list_pop_front(args)
    ans(cache_dir)

    if(NOT cache_dir)
      cmakepp_config(cache_dir)
      ans(cache_dir)
      set(cache_dir "${cache_dir}/package_cache")
    endif()

    path_qualify(cache_dir)

    set(this)
    assign(!this.cache_dir = cache_dir)
    assign(!this.inner = inner)

    assign(!this.query = 'package_source_query_cache')
    assign(!this.resolve = 'package_source_resolve_cache')
    assign(!this.pull = 'package_source_pull_cache')

    return_ref(this)
  endfunction()


  github_package_source()

endfunction()