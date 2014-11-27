## captures the listed variables in the map
function(map_capture map)
  foreach(__map_capture_arg ${ARGN})
    map_set(${map} "${__map_capture_arg}" "${${__map_capture_arg}}")
  endforeach()
endfunction()

