function(test)

  ## same as file_data_write except that an <obj> is parsed 
  function(file_data_write_obj dir id obj)
    obj("${obj}")
    ans(obj)
    file_data_write("${dir}" "${id}" "${obj}")
    return_ans()
  endfunction()



function(file_data_path dir id)
  path("${dir}/${id}.cmake")
  ans(path)
  return_ref(path)    
endfunction()

function(file_data_clear dir id)
  file_data_path("${dir}" "${id}")
  ans(path)
  if(NOT EXISTS "${path}")
    return(false)
  endif()
  rm("${path}")
  return(true)
endfunction()
## returns all identifiers for specified file data directory
function(user_data_ids dir)
  path("${dir}")
  ans(dir)
  file_glob("${dir}" *.cmake)

  ans(files)
  set(keys)
  foreach(file ${files})
    path_component("${file}" --file-name)
    ans(key)
    list(APPEND keys "${key}")
  endforeach()
  return_ref(keys)
endfunction()


function(file_data_write dir id)
  file_data_path("${dir}" "${id}")
  ans(path)
  qm_write("${path}" ${ARGN})
  return_ref(path)
endfunction()

function(file_data_read dir id)
  file_data_path("${dir}" "${id}")      
  ans(path)
  if(NOT EXISTS "${path}")
    return()
  endif()
  qm_read("${path}")
  return_ans()
endfunction()


function(file_data_get dir id)
  set(nav ${ARGN})
  file_data_read("${dir}" "${id}")
  ans(res)
  if("${nav}_" STREQUAL "_" OR "${nav}_" STREQUAL "._")
    return_ref(res)
  endif()
  nav(data = "res.${nav}")
  return_ref(data)
endfunction()

function(file_data_set dir id nav)
  set(args ${ARGN})

  if("${nav}" STREQUAL "." OR "${nav}_" STREQUAL "_")
    file_data_write("${dir}" "${id}" ${ARGN})
    return_ans()
  endif()
  file_data_read("${dir}" "${id}")
  ans(res)
  map_navigate_set("res.${nav}" ${ARGN})
  file_data_write("${dir}" "${id}" ${res})
  return_ans()
endfunction()


  


  

  function(config_data_get dirs id)
    set(res)
    foreach(dir ${dirs})
      file_data_get("${dir}" "${id}" ${ARGN})
      ans(res)
      if(res)
        break()
      endif()
    endforeach()
    return_ref(res)
  endfunction()

  function(config_data_set dirs id nav)
    list_pop_front(dirs)
    ans(dir)

    file_data_set("${dir}" "${id}" "${nav}" ${ARGN})
    return_ans()
  endfunction()

  function(config_data_read dirs id nav)    
    set(maps )
    foreach(dir ${dirs})
      file_data_read(dir "${id}")
      ans(res)
      list(APPEND maps "${res}")
    endforeach()
    #map_merge(${maps})
    json_print(${maps})
    #return_ans()
  endfunction()



  file_data_write_obj(dir1 mydata "{id:1, a:1}")
  file_data_write_obj(dir2 mydata "{id:2, b:2}")
  file_data_write_obj(dir3 mydata "{id:3, c:3}")

  file_data_read("dir1;dir2;dir3" mydata)
  ans(res)
  
  return()
  function(map_equals_obj lhs rhs)
    obj("${lhs}")
    ans(lhs)
    obj("${rhs}")
    ans(rhs)
    map_equals_obj("${lhs}" "${rhs}")
    return_ans()
  endfunction()

  json_print(${res})
  map_equals_obj("${res}" "{id:1,a:1,b:2,c:3}")











endfunction()


