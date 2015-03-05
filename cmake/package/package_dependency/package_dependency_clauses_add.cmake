
  function(package_dependency_clauses_add clauses package_handle_map package_uri )
    map_tryget("${package_handle_map}" "${package_uri}")
    ans(dependee_handle)

    map_tryget(${dependee_handle} dependencies)
    ans(dependencies)

    map_tryget(${dependee_handle} package_descriptor)
    ans(package_descriptor)

    map_tryget("${package_descriptor}" dependencies)
    ans(conditions)


    map_keys(${dependencies})
    ans(admissable_uris)

    foreach(admissable_uri ${admissable_uris})
      map_tryget("${conditions}" "${admissable_uri}")
      ans(dependency_conditions)

      ## gets all dependency handles for admissable_uri
      map_tryget("${dependencies}" "${admissable_uri}")
      ans(dependency_handle_map)
      set(dependency_handles)
      set(dependency_uris)
      if(dependency_handle_map)
        map_values(${dependency_handle_map})
        ans(dependency_handles)
        map_keys(${dependency_handle_map})
        ans(dependency_uris)
      endif()

#      print_vars(package_uri admissable_uri dependency_uris)



      ## multiple dependecy handles per admissable uri
      if(NOT "${dependency_conditions}" MATCHES "^(true)|(false)$")
        message(FATAL_ERROR "comlpex dependency conditions not supported")
      endif()

      if("${dependency_conditions}" STREQUAL "false")
        foreach(dependency_handle ${dependency_handles})
          map_tryget(${dependency_handle} uri)
          ans(dependency_uri)
          sequence_add(${clauses} "!${package_uri}" "!${dependency_uri}")
          ans(ci)
        endforeach()
      else()
        sequence_add(${clauses} "!${package_uri}")
        ans(ci)
        # todo complex conditions
        foreach(dependency_handle ${dependency_handles})
          map_tryget(${dependency_handle} uri)
          ans(dependency_uri)
          sequence_append("${clauses}" "${ci}" "${dependency_uri}")
        endforeach()

      endif()

    endforeach()
  endfunction()