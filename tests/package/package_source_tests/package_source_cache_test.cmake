function(test)

  function(key_value_store)
    set(args ${ARGN})
    list_pop_front(args)
    ans(store_dir)

    path_qualify(store_dir)

    map_new()
    ans(this)

    assign(this.store_dir = store_dir)
    assign(this.save = 'key_value_store_save')
    assign(this.load = 'key_value_store_load')
    assign(this.list = 'key_value_store_list')
    assign(this.keys = 'key_value_store_keys')
    assign(this.key = '')
    return(${this})
  endfunction()
  function(key_value_store_save)
    this_get(store_dir)
    assign(key = this.key(${ARGN}))
    qm_write("${store_dir}/${key}" ${ARGN})    
    return_ref(key)
  endfunction()
  function(key_value_store_load key)
    this_get(store_dir)
    if(NOT EXISTS "${store_dir}/${key}")
      return()
    endif()
    qm_read("${store_dir}/${key}")
    return_ans()
  endfunction()

  function(key_value_store_keys)
    this_get(store_dir)
    file(GLOB keys RELATIVE "${store_dir}" "${store_dir}/*")
    return_ref(keys)
  endfunction()

  function(key_value_store_list)
    key_value_store_keys()
    ans(keys)
    set(values)
    foreach(key ${keys})
      key_value_store_load("${key}")
      ans_append(values)
    endforeach()  
    return_ref(values)
  endfunction()


  key_value_store("kv1")
  ans(store)

  assign(store.key = 'checksum_string')

  assign(allkeys = store.keys())
  assert(NOT allkeys)

  assign(key = store.save("hello world!"))
  assert(key)

  assign(value = store.load("${key}"))
  assert("${value}" STREQUAL "hello world!")

  assign(allkeys = store.keys())
  assert(allkeys)

  assert("${allkeys}" STREQUAL "${key}")

  

  function(indexed_store)
    key_value_store(${ARGN})
    ans(this)
    assign(this.find = 'indexed_store_find')
    assign(this.find_keys = 'indexed_store_find_keys')
    assign(this.save = 'indexed_store_save')
    assign(this.index_list = 'indexed_store_index_list')
    assign(this.index_add = 'indexed_store_index_add')
    assign(this.index_rebuild = 'indexed_store_index_add')

    assign(store_dir = this.store_dir)
    set(value_dir "${store_dir}/value")
    set(index_dir "${store_dir}/index")
    set(lookup_dir "${store_dir}/lookup" )
    key_value_store("${index_dir}")
    ans(index_store)
    assign(this.index_store = index_store)
    assign(this.store_dir = value_dir)
    assign(this.lookup_dir = lookup_dir)
    assign(this.index_store.key = 'indexed_store_index_key')

    assign(indices = index_store.list())
    return(${this})
  endfunction()

  function(indexed_store_index_key index)
    map_tryget(${index} name)
    return_ans()
  endfunction()


  function(indexed_store_find)
    indexed_store_find_keys(${ARGN})
    ans(keys)
    set(values)
    foreach(key ${keys})
      key_value_store_load("${key}")
      ans_append(values)
    endforeach()
    return_ref(values)
  endfunction()

  function(indexed_store_find_keys)

  endfunction()
 
  function(indexed_store_save)
    key_value_store_save("${ARGN}")
    ans(key)

    indexed_store_index_build("${key}" "${value}")
    return_ref(key)
  endfunction()
 
  function(indexed_store_index_list)
    return_ref(indices)
  endfunction()

  function(indexed_store_index_add index)
    obj("${index}")
    ans(index)
    assign(success = this.index_store.save(${index}))
    assign(!this.indices[] = index)
    indexed_store_index_rebuild(${index})
    return()
  endfunction()

  function(indexed_store_index_remove)
  
  endfunction()
  
  function(indexed_store_index_rebuild index)
    this_get(lookup_dir)
    assign(index_name = index.name)
    rm("${lookup_dir}/${index_name}")
    key_value_store_keys()
    ans(keys)
    foreach(key ${keys})
      indexed_store_index_build("${index}" "${key}")
    endforeach()
    return()
  endfunction()

  function(indexed_store_index_value value)
    this_get(indices)
    ans(indices)

    foreach(index ${indices})
      indexed_store_index_build("${index}" "${value}")
    endforeach()
    return()
  endfunction()

  function(indexed_store_index_build index key)
    map_new()
    ans(index_entry)

    
    this_get(lookup_dir)

    assign(value = this.load("${key}"))

    assign(index_name = index.name)
    set(index_lookup_dir "${lookup_dir}/${index_name}")

    qm_write("${index_lookup_dir}/${key}" "${index_entry}")

    return_ref(index_entry)
  endfunction()



  indexed_store("index_store")
  ans(uut)




  assign(uut.key = "'(a)-> map_tryget($a id)'")
  #json_print(${uut})



  assign(idx = uut.index_add("{id:'idx1',value:'gagagaga'}"))



  assign(key = uut.save("{id:'abc'}"))






  return()
  function(cached_package_source inner)
    set(args ${ARGN})
    list_pop_front(args)
    ans(cache_dir)

    if(NOT cache_dir)
      oocmake_config(cache_dir)
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


  function(cache_create)
    map_new()
    ans(this)
    
    set(args ${ARGN})
    list_pop_front(args)
    ans(cache_dir)
    path_qualify(cache_dir)

    assign(this.cache_dir = cache_dir)

    assign(this.value_indices = 'cache_value_indices')
    assign(this.hash_value = 'cache_value_hash')
    assign(this.register_value = 'cache_value_register')
    assign(this.register_values = 'cache_values_register')
    assign(this.save_value = 'cache_value_save')
    assign(this.load_value = 'cache_value_load')
    return_ref(this)
  endfunction()

  function(cache_value_save key value)
    this_get(cache_dir)
    qm_write("${cache_dir}/values/${key}.qm" "${value}")    
    return(true)
  endfunction()
  function(cache_value_load key)
    this_get(cache_dir)
    qm_read("${cache_dir}/values/${key}.qm")
    return_ans()    
  endfunction()

  function(cache_value_register value)
    assign(hash = this.hash_value(${value}))


    set(value_container)
    assign(!value_container.value = value)

    # create indices
    assign(success = register_value_indices(${hash} ${value_container}))

    assign(success = this.save_value("${hash}" "${value_container}"))

    return_ref(hash)
  endfunction()


  function(cache_values_register)
    set(result)
    foreach(value ${ARGN})
      assign(result[] = this.register_value(${value}))
    endforeach()
    return_ref(result)
  endfunction()

  function(cache_values_register_indices key value_container)
    assign(value = value_container.value)
    assign(indices = this.value_indices(${value}))

    assign(success = this.save_indices(${indices}))
  endfunction()

  function(cache_indices_save)


  endfunction()

  function(cache_value_indices value)
    return()
  endfunction()
  function(cache_value_hash value)
    assign(hash = value.uri)
    assign(hash = string_normalize(${hash}))
    return_ref(hash)
  endfunction()


  cache_create(".")
  ans(uut)

  package_source_query_github("toeb/cmakepp" --package-handle)
  ans(handles)
  print_vars(handles)
  assign(hashes = uut.register_values(${handles}))


return()
  map_new()
  ans(cache_data)



  function(cache_register_value query value)
    uri("${query}")
    ans(uri)




  endfunction()

  function(cache_register_values query)
    set(values ${ARGN})
    foreach(value ${values})
      cache_register_value("${query}" "${value}")
    endforeach()
    return()
  endfunction()






  function(package_source_query_cache uri)
    set(args ${ARGN})

    uri("${uri}")
    ans(uri)

    list_extract_flag(args --package-handle)
    ans(return_package_handle)


    list_extract_flag(args --refresh)
    ans(return_package_handle)

    this_get(cache_dir)



    assign(package_handles = inner.query(${uri} --package-handle))

    cache_register(${uri} ${package_handles})

    return_ref(package_handles)

  endfunction()

  github_package_source()
  ans(inner)
  cached_package_source(${inner})
  ans(uut)

  assign(result = uut.query("toeb"))

  print_vars(result)

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