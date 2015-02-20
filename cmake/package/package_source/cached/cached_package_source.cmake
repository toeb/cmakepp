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

  assign(!this.indexed_store = indexed_store("${cache_dir}/store"))
  assign(index = this.indexed_store.index_add("package_handle.uri"))
  assign(index = this.indexed_store.index_add("package_handle.query_uri"))
  assign(index = this.indexed_store.index_add("package_handle.package_descriptor.id"))
  assign(this.indexed_store.key = "'[](container) ref_nav_get({{container}} package_handle.uri)'")


  assign(!this.clear_cache = 'package_source_cached_clear_cache')
  assign(!this.query = 'package_source_query_cached')
  assign(!this.resolve = 'package_source_resolve_cached')
  assign(!this.pull = 'package_source_pull_cached')

  return_ref(this)
endfunction()

function(package_source_cached_clear_cache)
  this_get(cache_dir)
  rm(-r "${cache_dir}")
endfunction()