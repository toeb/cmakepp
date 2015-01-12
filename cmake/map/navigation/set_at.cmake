
  function(set_at ref)
    set(args ${ARGN})
    list_pop_front(args)
    ans(first)



    if(NOT args)
      # single value
      set(${ref} ${first})
    elseif("${first}" MATCHES "^\\[.*\\]$")
      # indexer
      list(LENGTH ${ref} len)
      string(REGEX REPLACE "\\[(.*)\\]" "\\1" indexer "${first}")

      if("${indexer}_" STREQUAL "_")
        set(indexer ${len})
      endif()   

      if("${indexer}" EQUAL ${len})
        set(indexer -1)
      endif()


      list_set_at(${ref} ${indexer} ${args})
    

    else()  
      # map key
      map_isvalid("${${ref}}")
      ans(is_map)
      if(NOT __ans)
        map_new()
        ans(${ref})
      endif()

      list(GET args 0 indexer)

      if("${indexer}" MATCHES "^\\[.*\\]$")
        list_pop_front(args)
        map_tryget(${${ref}} ${first})
        ans(val)
        list(LENGTH val len)
        string(REGEX REPLACE "\\[(.*)\\]" "\\1" indexer "${indexer}")
        if("${indexer}_" STREQUAL _)
          set(indexer ${len})
        endif()
        if(NOT "${indexer}" LESS ${len})
          set(indexer -1)
        endif()
        list_set_at(val ${indexer} ${args})

        set(args ${val})

      endif()

      map_set("${${ref}}" "${first}" ${args})

      # key
    endif()

    set(${ref} ${${ref}} PARENT_SCOPE)
    return_ref(${ref})

  endfunction()

