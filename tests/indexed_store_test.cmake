function(test)


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


return()
  indexed_store("index_store")
  ans(uut)




  assign(uut.key = "'[](a) map_tryget({{a}} id)'")
  #json_print(${uut})



  assign(idx = uut.index_add("{id:'idx1',value:'gagagaga'}"))



  assign(key = uut.save("{id:'abc'}"))



endfunction()