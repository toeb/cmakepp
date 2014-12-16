## captures the listed variables in the map
function(map_capture map )
  set(__map_capture_args ${ARGN})
  list_extract_flag(__map_capture_args --notnull)
  ans(__not_null)
  foreach(__map_capture_arg ${ARGN})
    if(NOT __not_null OR NOT "${${__map_capture_arg}}_" STREQUAL "_")
      map_set(${map} "${__map_capture_arg}" "${${__map_capture_arg}}")
    endif()
  endforeach()
endfunction()

