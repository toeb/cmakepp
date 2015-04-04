##
##
## takes a specific dependency configuration and a set of package descriptors from
## a package graph obtained by package_dependency_graph_resolve and updates 
## the package_handle's dependencies property to contain a single unique package handle 
## for every admissable_uri. before the dependencies property maps admissable_uri x {package uri x package handle}
##
function(package_dependency_configuration_set configuration)
  if(NOT configuration)
    message(FATAL_ERROR "package_dependency_configuration_set: expected a valid configuration map")
  endif()
  set(package_handles ${ARGN})

  foreach(package_handle ${package_handles})
    map_tryget(${package_handle} dependencies)
    ans(dependencies)
    if(dependencies)
      map_keys(${dependencies})
      ans(admissable_uris)

      foreach(admissable_uri ${admissable_uris})
        map_tryget(${dependencies} ${admissable_uri})
        ans(possible_dependencies)
        map_values(${possible_dependencies})
        ans(possible_dependencies)
        map_set(${dependencies} ${admissable_uri})

        foreach(possible_dependency ${possible_dependencies})
          map_tryget(${possible_dependency} uri)
          ans(possible_dependency_uri)
          map_has(${configuration} ${possible_dependency_uri})
          ans(has_uri)
          if(has_uri)
            map_set(${dependencies} ${admissable_uri} ${possible_dependency})
            break()
          endif()
        endforeach()
      endforeach()

    endif()
  endforeach()
endfunction()