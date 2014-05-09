function(cached arg)
    json("${arg}")
    ans(ser)
    string(MD5 cache_key "${ser}")
    set(args ${ARGN})
    list(LENGTH args arg_len)
    if(arg_len)

      map_set(global_cache_entries "${cache_key}" "${args}")
      return_ref(args)
    endif()


    map_tryget(global_cache_entries "${cache_key}")    
    ans(res)
    return_ref(res)


endfunction()
  macro(return_hit arg_name)
    cached("${${arg_name}}")
    if(__ans)
      message("hit")
      return_ans()
    endif()
      message("not hit")
  endmacro()



function(file_cache cache_key)
  json("${cache_key}")
  ans(serialized_key)
  string(MD5 key "${serialized_key}")

  if(EXISTS "${cutil_temp_dir}/file_cache/_${key}.cmake")
    file(READ "${cutil_temp_dir}/file_cache/_${key}.cmake" data)
    qm_deserialize("${data}")
    return_ans()
  endif()
  return()
endfunction()

function(file_cache_update cache_key)
  json("${cache_key}")
  ans(serialized_key)
  string(MD5 key "${serialized_key}")
  qm_serialize("${ARGN}")
  ans(ser)
  file(WRITE "${cutil_temp_dir}/file_cache/_${key}.cmake" "${ser}")
  return()  
endfunction()

macro(file_cache_return_hit cache_key)
  file_cache("${cache_key}")
  ans(__cache_return)
  if(__cache_return)
    return_ref(__cache_return)
  endif()

endmacro()