# runs dfs recursively
# expects a config object:
# {
#  expand: (node)->node[] # expand the specified node,
#  enter: (node)->void # called before successors are evaluated
#  leave: (node)->void # called after node's successors were evaluated
# }
# expand has the following available vars
# - ${path} contains path to the current node (including current node)
# - ${parent} contains the node from which current node was called
# enter has the following available vars
# - all expand vars
# - ${successors} contains all direct successors of current node
# - ${enter} (boolish) can be checked to see if currently entering a node (if enter and leave callbacks are the same function)
# leave has the following available vars
# - all expand vars
# - ${successors} same as enter
# - ${leave} (boolish) can be checked to see if node is currently being left (if enter and leave callbacks are the same function)
# - ${visited} contains all nodes which were visited in recursive calls below current node
#    visited may contain duplicates depending on the graph

  function(dfs_recurse config)
    obj("${config}")
    ans(dfs_config)

    function(dfs_inner current)
      set(path ${path} ${current})
      # get successors
      map_tryget(${dfs_config} expand)
      ans(expand)

      if(NOT expand)
        message(FATAL_ERROR "expected a expand function")
      endif()

      
      rcall(successors = "${expand}"(${current}))
      
      map_tryget(${dfs_config} enter)
      ans(enter)
      if(enter)
        set(leave)
        call("${enter}"(${current}))
      endif()
      set(enter)

      

      set(parentparent ${parent})
      set(parent ${current})
      foreach(successor ${successors})
        dfs_inner(${successor})
      endforeach()
      set(parent ${parentparent})

      set(visited ${visited} ${successors} PARENT_SCOPE)
      set(visited ${visited} ${successors})

      map_tryget(${dfs_config} leave)
      ans(leave)

      if(leave)
        set(enter)
        call("${leave}"(${current}))
      endif()
      set(leave)
    endfunction()



    set(visited)
    foreach(root ${ARGN})
      set(path)
      dfs_inner(${root})
    endforeach()

    return()

  endfunction()