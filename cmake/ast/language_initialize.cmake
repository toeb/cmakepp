
function(language_initialize language)
  # sets up the language object
    
  map_tryget(${language}  initialized)
  ans(initialized)
  if(initialized)
    return(${language})
  endif()


  # setup token definitions

  # setup definition names
  map_get(${language}  definitions)
  ans(definitions)
  map_keys(${definitions})
  ans(keys)
  foreach(key ${keys})
    map_get(${definitions}  ${key})
    ans(definition)
    map_set(${definition} name ${key} )
  endforeach()  

  #
  token_definitions(${language})
  ans(token_definitions)
  map_set(${language} token_definitions ${token_definitions})

  map_set(${language} initialized true)


  # extract phases
  map_tryget(${language} phases)
  ans(phases)
#  ref_isvalid("${phases}")
#  ans(isref)
#  if(isref)
#    ref_get(${phases})
#    ans(phases)
#  endif()
  map_set(${language} phases "${phases}")


  # setup self reference
  map_set(${language} global ${language})
  

  # setup outputs
  foreach(phase ${phases})
    map_tryget(${phase} name)
    ans(name)
    map_set("${language}" "${name}" "${phase}")

    map_tryget("${phase}" output)
    ans(outputs)
    if(outputs)
 #     ref_isvalid("${outputs}")
 #     ans(isref)
#      if(isref)
 #       ref_get(${outputs})
  #      ans(outputs)
   #   endif()
      map_set("${phase}" output "${outputs}")

      foreach(output ${outputs})
        map_set(${language} "${output}" "${phase}")
      endforeach()
    endif()
  endforeach()



  # setup inputs
  foreach(phase ${phases})
    map_tryget("${phase}" input)
    ans(inputs)
    if(inputs)
#      ref_isvalid("${inputs}")
 #     ans(isref)
  #    if(isref)
   #     ref_get(${inputs})
    #    ans(inputs)
    # endif()
      map_set("${phase}" input "${inputs}")
     # message("inputs for phase ${phase} ${inputs}")

      foreach(input ${inputs})
        map_tryget(${language} "${input}")
        ans(val)
        if(NOT val)
          map_set(${language} "${input}" "missing")
        
         # message("missing input: ${input}")
        endif()

      endforeach()
    endif()
  endforeach()


endfunction()