
  function(parse_sequence rstring) 
    # create a copy from rstring 
    ref_get(${rstring})
    ans(str)
    ref_setnew("${str}")
    ans(str)

    # get sequence definitions
    map_get(${definition} sequence)
    ans(sequence)

    map_keys(${sequence})
    ans(sequence_keys)

    # match every element in sequence
    map_new()
    ans(result_map)
    foreach(sequence_key ${sequence_keys})

      map_tryget("${sequence}" "${sequence_key}")
      ans(sequence_id)

      if("${sequence_id}" MATCHES "^@")
        string(SUBSTRING "${sequence_id}" 1 -1 sequence_id)
        map_set("${result_map}" "${sequence_key}" "${sequence_id}")
     
      else()
        set(ignore false)
        set(optional false)
        if("${sequence_id}" MATCHES "^\\?")
          string(SUBSTRING "${sequence_id}" 1 -1 sequence_id)
          set(optional true)
        endif()
        if("${sequence_id}" MATCHES "^/")
          string(SUBSTRING "${sequence_id}" 1 -1 sequence_id)
          set(ignore true)
        endif()


        parse_string("${str}" "${sequence_id}")
        ans(res)

        list(LENGTH res len)


        if(${len} EQUAL 0 AND NOT optional)
          return()
        endif()

        if(NOT "${ignore}")
          map_set("${result_map}" "${sequence_key}" "${res}")
        endif()
      endif()
    endforeach()

    # if every element was  found set rstring to rest of string
    ref_get(${str})
    ans(str)
    ref_set(${rstring} "${str}")

    # return result
    return_ref(result_map)
  endfunction()