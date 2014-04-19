
function(language_initialize language)

    
  map_tryget(${language} initialized initialized)
  if(initialized)
    return(${language})
  endif()
  # setup token definitions

  # setup definition names
  map_get(${language} definitions definitions)
  map_keys(${definitions} keys)
  foreach(key ${keys})
    map_get(${definitions} definition ${key})
    map_set(${definition} name ${key} )
  endforeach()  

  #
  token_definitions(${language})
  ans(token_definitions)
  map_set(${language} token_definitions ${token_definitions})

  map_set(${language} initialized true)
endfunction()