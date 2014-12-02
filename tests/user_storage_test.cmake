function(test)
  
  ## returns the user data path for the specified id
  ## normally located in %HOME_DIR%/.oocmake
  function(user_data_path)  
    if(NOT id)
      message(FATAL_ERROR)
    endif()

    #checksum_string("${id}")
    #ans(id)
    
    home_dir()
    ans(home_dir)
    set(storage_dir "${home_dir}/.oocmake")
    if(NOT EXISTS "${storage_dir}")
      mkdir("${storage_dir}")
    endif()
    set(storage_file "${storage_dir}/${id}.cmake")
    return_ref(storage_file)
  endfunction()


  function(user_data_read id)
    user_data_path("${id}")
    ans(storage_file)

    if(NOT EXISTS "${storage_file}")
      return()
    endif()

    qm_read("${storage_file}")
    return_ans()
  endfunction()

  function(user_data id)
    user_data_read("${id}")
    ans(res)
    if(NOT res)

    endif()
    return_ref(res)
  endfunction()

  function(user_data_clear id)
    user_data_path("${id}")
    ans(res)
    if(EXISTS "${res}")
      rm("${res}")
      return(true)
    endif()
    return(false)
  endfunction()


  function(user_data_write id)
    user_data_path("${id}")
    ans(path)

    qm_write("${path}" ${ARGN})
    return_ans()
  endfunction()




  user_data_path(testkey)
  ans(res)
  message("user data is located in ${res}")


  user_data_clear("testkey")

  # read empty user data
  user_data_read("testkey")
  ans(res)
  assert("${res}_" STREQUAL "_")


  # write simple user_data
  user_data_write("testkey" hello)
  ans(res)
  assert(EXISTS "${res}")

  user_data_read("testkey")
  ans(res)
  assert("${res}" STREQUAL "hello")


  # read/write complex user_data
  map()
    kv("h1" h1)
    kv("h2" h1)
    kv("h3" h1)
    kv("h4" h1)
    map(43)
      kv(jasd  asd)
    end()

  end()
  ans(res)

  user_data_write(testkey "${res}")

  user_data_read(testkey)
  ans(res2)

  map_equal("${res}" "${res2}")
  ans(isequal)

  assert(isequal)
  assert(NOT "${res}" STREQUAL "${res2}")


  
  function(user_data_set nav)
    set(args ${ARGN})
    list_extract_labelled_value(args --user-data-id)
    ans(id)
    if(NOT id)
      set(id default)
    endif()
    user_data_read("${id}")
    ans(res)
    message("res.${nav} ${args}")
    map_navigate_set("${res}.${nav}" ${args})
    json_print(${res})
    user_data_write("${id}" ${res})
    return_ans()
  endfunction()

  function(user_data_get expr)
    set(args ${ARGN})
    list_extract_labelled_value(args --user-data-id)
    ans(id)
    if(NOT id)
      set(id default)
    endif()
    user_data_read("${id}")
    ans(res)
    nav(data = res."${expr}")
    return_ref(data)
  endfunction()


  user_data_set(my.value 123 --user-data-id testkey)
  nav(res.my.value  123)

  user_data_read("testkey")
  ans(res2)

  map_equal("${res2}" "${res}")

  ans(isequal)
  assert(isequal)





endfunction()