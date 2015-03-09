## `()->`
##
##
function(package_dependency_changeset_parse)
  map_new()
  ans(changeset)
  foreach(action ${ARGN})
    package_dependency_change_parse("${action}")
    ans_extract(admissable_uri)
    ans(action)
    if(NOT "${admissable_uri}_" STREQUAL "_")
      map_set("${changeset}" "${admissable_uri}" "${action}")
    endif()
  endforeach()
  return_ref(changeset)
endfunction()