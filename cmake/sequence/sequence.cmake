
    macro(sequence_index_isvalid map idx)
      map_has("${map}" "${idx}")
    endmacro()

    function(sequence_set map idx)
      sequence_count(${map})
      ans(count)
      sequence_isvalid("${map}" "${idx}")
      ans(isvalid)
      if(NOT isvalid)
        return(false)
      endif()
      map_set("${map}" "${idx}" ${ARGN})
      return(true)
    endfunction()

    macro(sequence_get map idx)
      map_tryget("${map}" "${idx}")
    endmacro()

    function(sequence_append map idx)
      sequence_count("${map}")
      ans(count)
      if(NOT "${idx}" LESS "${count}" OR ${idx} LESS 0)
        message(FATAL_ERROR "sequence_set: index out of range: ${idx}")
      endif()

      map_append( "${map}" "${idx}" ${ARGN} )
      
    endfunction()

    function(sequence_append_string map idx)
      sequence_count("${map}")
      ans(count)
      if(NOT "${idx}" LESS "${count}" OR ${idx} LESS 0)
        message(FATAL_ERROR "sequence_set: index out of range: ${idx}")
      endif()

      map_append_string( "${map}" "${idx}" ${ARGN} )
      
    endfunction()

    function(sequence_add map)
      sequence_count("${map}")
      ans(count)
      math(EXPR new_count "${count} + 1")
      map_set_special("${map}" count ${new_count})
      map_set("${map}" "${count}" ${ARGN})
      return_ref(count)
    endfunction()

    function(sequence_isvalid map)
      sequence_count("${map}")
      ans(is_lookup)

      if("${is_lookup}_" STREQUAL "_" )
        return(false)
      endif()
      return(true)
    endfunction()

    macro(sequence_count map)
      map_get_special("${map}" count)
    endmacro()

    function(sequence_new)
      ref_isvalid("${ARGN}")
      ans(isref)
      if(NOT isref)
        map_new()
        ans(map)
      else()
        set(map ${ARGN})
      endif()

      map_set_special(${map} count 0)
      return_ref(map)
    endfunction()