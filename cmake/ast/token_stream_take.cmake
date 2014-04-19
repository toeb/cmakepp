
  function(token_stream_take stream token_definition)
   # message(FORMAT "trying to take {token_def_or_name.name}")
    map_tryget(${stream} current current)
    if(NOT current)
      return()
    endif()
#    message(FORMAT "current token '{current.data}'  is a {current.definition.name}, expected {definition.name}")
    
    map_tryget(${current} definition definition)
    
    if(${definition} STREQUAL ${token_definition})
   
      map_tryget(${current} next next)
      map_set_hidden(${stream} current ${next})
      return(${current})
    endif()
    return()
  endfunction()