function(test)


  function(exp i)
    if("${i}" EQUAL 1)
      return(2 3)
    endif()

    if(${i} EQUAL 2)
      return(3 4 5)
    endif()

    if(${i} EQUAL 3)
      return(5 6 7)
    endif()
    return()
  endfunction()

  
  dfs_recurse("{
    expand:'(it)-> message(expand $it ) \n exp($it)',
    enter:'(it)-> message(enter $it from $parent path $path successors $successors) \n message_indent_push()',
    leave:'(it)-> message_indent_pop() \n message(leave $it to $parent visited $visited)'

    }" 1)



endfunction()