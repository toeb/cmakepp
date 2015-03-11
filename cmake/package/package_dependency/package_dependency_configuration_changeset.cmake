## `(<lhs: <dependency configuration>> <rhs:<dependency configuration>>-><changeset>`
## 
## compares two dependency configurations and returns a resulting changeset
## the `<changeset> ::= { <dependable uri>:"install"|"uninstall"}` 
function(package_dependency_configuration_changeset lhs rhs)
    set(package_uris)
    map_keys(${lhs})
    ans_append(package_uris)
    map_keys(${rhs})
    ans_append(package_uris)
    list_remove_duplicates(package_uris)

    map_new()
    ans(changeset)


    foreach(package_uri ${package_uris})
      map_tryget(${lhs} ${package_uri})
      ans(before)
      map_tryget(${rhs} ${package_uri})
      ans(after)

      set(action)

      if(NOT after)
        if(NOT "${before}_" STREQUAL "false_")
          set(action uninstall)
        endif()
      elseif(after AND NOT before)
        set(action install)

      endif()

      if(action)
        map_set(${changeset} ${package_uri} ${action})
      endif()
    endforeach()

    return_ref(changeset)
endfunction()  