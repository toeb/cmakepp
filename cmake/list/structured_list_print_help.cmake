
  function(list_structure_print_help structure)
    map_keys(${structure} )
    ans(keys)

    set(descriptors)
    set(structure_help)
    foreach(key ${keys})

      map_get(${structure}  ${key})
      ans(descriptor)
      value_descriptor_parse(${key} ${descriptor})
      ans(descriptor)
      list(APPEND descriptors ${descriptor})

      map_import(${descriptor})
      set(current_help)
      list(GET labels 0 first_label)
      set(current_help ${first_label})

      if(${min} EQUAL 0)
        set(current_help "[${current_help}]")
      endif()


      set(structure_help "${structure_help} ${current_help}")

    endforeach()
    if(structure_help)
      string(SUBSTRING "${structure_help}" 1 -1 structure_help)
    endif()
    message("${structure_help}")
    message("Details: ")
    foreach(descriptor ${descriptors})
      map_import(${descriptor})
      list_to_string(res labels ", ")
      
      message("${displayName}: ${res}")
      if(description)
        message(PUSH)
        message("${description}")
        message(POP)
      endif()

    endforeach()
  endfunction()
