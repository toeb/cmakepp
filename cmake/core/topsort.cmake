# executes the topological sort for a list of nodes (passed as varargs)
# get_hash is a function to be provided which returns the unique id for a node
# this is used to check if a node was visited previously
# expand should take a node and return its successors
# this function will return nothing if there was a cycle or if no input was given
# else it will return the topological order of the graph
function(topsort get_hash expand)
  # visitor function
  function(topsort_visit result visited node)
    # get hash for current node
    call("${get_hash}" ("${node}"))
    ans(hash)

    map_tryget("${visited}" "${hash}")
    ans(mark)
    
    if("${mark}" STREQUAL "temp")
      # cycle
    #  message("cycle found")
      return(true)
    endif()
    if(NOT mark)
    #  message("visited ${visited} hash ${hash}")
      map_set("${visited}" "${hash}" temp)
      call("${expand}" ("${node}"))
      ans(successors)
    #  message("successors: ${successors}")
      # visit successors
      foreach(successor ${successors})
        topsort_visit("${result}" "${visited}" "${successor}")
        ans(cycle)
        if(cycle)
      #    message("cycle found")
          return(true)
        endif()
      endforeach()

      #mark permanently
      map_set("${visited}" "${hash}" permanent)

      # add to front of result
      ref_prepend("${result}" "${node}")
    endif()
    return(false)
  endfunction()


  map_new()
  ans(visited)
  ref_new()
  ans(result)

  # select unmarked node and visit
  foreach(node ${ARGN})
    # get hash for node
    call("${get_hash}" ("${node}"))
    ans(hash)
    
    # get marking      
    map_tryget("${visited}" "${hash}")
    ans(mark)
    if(NOT mark)
      topsort_visit("${result}" "${visited}" "${node}")
      ans(cycle)
      if(cycle)
       # message("stopping with cycle")
        return()
      endif()
    endif()

  endforeach()
#  message("done")
  ref_get(${result})

  return_ans()
endfunction()