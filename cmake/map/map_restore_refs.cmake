 # todo: complete
 function(map_restore_refs ref)
    map_new()
    ans(ref_ids)

    function(map_restore_find_refs cancel node)
      ref_isvalid(${node})
      ans(isref)
      map_isvalid(${node})
      ans(ismap)

      if(ismap)
        map_tryget(${node}  "$id")
        ans(id)
        if(id)
          map_set(${ref_ids} "${id}" ${node})
        endif()
      endif()
    endfunction()
    function(map_restore_restore_refs cancel node)

    endfunction()

    # find refs
    map_graphsearch(VISIT map_restore_find_refs ${ref})
    map_graphsearch(VISIT map_restore_restore_refs ${ref})

    
    #restore refs
   # map_print(${ref_ids})
   # map_print(${ref})
  endfunction()