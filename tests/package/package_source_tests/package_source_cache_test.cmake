function(test)
return()
  function(index_write index index_dir index_value)
      map_iterator(${index})
      ans(it)
      set(it.end false)
      while(true)
        map_iterator_break(it)
        set(index_file "${index_dir}/${it.key}/${it.value}.qm")
        fwrite("${index_file}" "${index_value}")
      endwhile()
  endfunction()

  function(index_add index index_name value )
    map_new()
    ans(data)
    checksum_string("${value}")
    ans(value_hash)
    map_set(${data} hash "${value_hash}")
    map_set(${data} value ${value})
    map_set(${index} "${index_name}" ${data})
    return(${data})
  endfunction()

  function(index_generate uri)
    uri("${uri}")
    ans(uri)

    map_new()
    ans(index)
    
    assign(query_uri = uri.uri)
    index_add(${index} query_uri "${query_uri}")

    assign(resource_uri = uri_format("${uri}" --no-query))
    index_add(${index} resource_uri "${resource_uri}")


  endfunction()

  function(generate_keys uri)
    
    map_new()
    ans(keys)

    checksum_string("uri${query_uri}")
    ans(key)

    map_set("${keys}" query_uri "${key}")


    assign(resource_uri = uri_format(${uri} --no-query))
    checksum_string("no_query${resource_uri}")
    ans(key)

    map_set("${keys}" resource_uri "${key}")



    assign(hash = uri.params.hash)
    if(hash)
      checksum_string("hash${hash}")
      ans(key)
      map_set("${keys}" hash "${key}")
    endif()

    return_ref(keys)
  endfunction()

  function(package_source_query_cache uri)
    set(args ${ARGN})

    list_extract_flag(args --package-handle)
    ans(return_package_handle)


    list_extract_flag(args --refresh)
    ans(refresh)

    uri("${uri}")
    ans(uri)

    this_get(inner)
    this_get(source_name)
    this_get(cache_dir)

    if(NOT cache_dir)
      oocmake_config(cache_dir)
      ans(cache_dir)
      set(cache_dir "${cache_dir}/package_source_cache")
    endif()

    set(index_dir "${cache_dir}/index")
    # generate cache keys
    timer_start(generate_keys)
    generate_keys("${uri}")
    ans(keys)
    timer_print_elapsed(generate_keys)

    set(found)

    if(NOT refresh)
      timer_start(find_indices)

      map_iterator(${keys})
      ans(it)
      while(true)
        map_iterator_break(it)
        set(index_file "${index_dir}/${it.key}/${it.value}.qm")
        if(EXISTS "${index_file}")
          qm_read("${index_file}")
          ans_append(found)
        endif()
      endwhile()
      timer_print_elapsed(find_indices)
    endif()
   

    if(NOT found OR refresh)
      timer_start(uncached)

      assign(package_handles = inner.query(${uri} --package-handle))
      foreach(package_handle ${package_handles})
        assign(unique_uri = package_handle.uri)
        checksum_string("${unique_uri}")
        ans(key)
        set(package_handle_path "${cache_dir}/${key}.qm")
        qm_write("${package_handle_path}" ${package_handle})
        
        set(index)
        assign(!index.package_handle_path = package_handle_path)
        assign(!index.resolved = 'false')
        qm_serialize("${index}")
        ans(serialized)

        assign(package_uri = package_handle.uri)
        generate_keys("${package_uri}")
        ans(new_keys)

        write_cached_data("${keys}" "${index_dir}" "${serialized}")
        write_cached_data("${new_keys}" "${index_dir}" "${serialized}")

      endforeach()
      timer_print_elapsed(uncached)

    else()
      timer_start(cached_get)
      set(package_handles)

      foreach(index ${found})
        map_tryget(${index} package_handle_path)
        ans(package_handle_path)
        qm_read("${package_handle_path}")
        ans(package_handle)
        message("${package_handle}")
        list(APPEND package_handle "${package_handle}")
      endforeach()
      timer_print_elapsed(cached_get)
    endif()

    if(NOT return_package_handle)
      list_select_property(package_handles uri)
      ans(package_handles)
    endif()


    return_ref(package_handles)
  endfunction()

  function(package_source_resolve_cache uri)
    ## check
  endfunction()
  function(package_source_pull_cache uri)

  endfunction()
  git(--version)
  git_package_source()
  github_package_source()
  ans(inner)

  map_new()
  ans(this)
  assign(this.inner = inner)
  assign(this.source_name = 'testcache')
  assign(this.cache_dir = '${test_dir}/cache')

  timer_start(t1)  
  package_source_query_cache("toeb" --package-handle)
  ans(res)
  message("${res}")

  timer_print_elapsed(t1)


  timer_start(t1)  
  package_source_query_cache("toeb" --package-handle)
  ans(res)
  message("${res}")
  timer_print_elapsed(t1)







endfunction()