## `(<package handle> <~package changeset>)-> <old changes>`
## 
## modified the dependencies of a package handle
## ```
##  package_handle_update_dependencies(${package_handle} "A" "B conflict") 
##  package handle: <%
##    map_new()
##   ans(package_handle)
##   package_handle_update_dependencies(${package_handle} "A" "B conflict")
##   template_out_json(${package_handle})
##  %>
## ```
function(package_handle_update_dependencies package_handle)
  if(NOT package_handle)
    message(FATAL_ERROR "package_handle_update_dependencies: no package handle specified")
    return()
  endif()
  package_dependency_changeset(${ARGN})
  ans(changeset)


  package_handle_dependencies("${package_handle}")
  ans(dependencies)
  
  map_new()
  ans(diff)

  map_keys(${changeset})
  ans(admissable_uris)
  
  foreach(admissable_uri ${admissable_uris})
    ## get previous value
    map_has(${dependencies} "${admissable_uri}")
    ans(has_constraint)

    if(has_constraint)
      map_tryget(${dependencies} "${admissable_uri}")
      ans(constraint)
      map_set(${diff} "${admissable_uri}" ${constraint})
    endif()

    ## set new value
    map_tryget(${changeset} ${admissable_uri})
    ans_extract(action)
    ans(constraint)



    if("${action}" STREQUAL "add")
      if(constraint)
        map_set(${dependencies} "${admissable_uri}" ${constraint})
      else()
        map_set(${dependencies} "${admissable_uri}" true)
      endif()
    elseif("${action}" STREQUAL "remove")
      map_remove(${dependencies} "${admissable_uri}")
    elseif("${action}" STREQUAL "conflict")
      map_set(${dependencies} ${admissable_uri} false)
    elseif("${action}" STREQUAL "optional")
      map_set(${dependencies} "${admissable_uri}")
    endif()    


  endforeach()
  return_ref(diff)
endfunction()


