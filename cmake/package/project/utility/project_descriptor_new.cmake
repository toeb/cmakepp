

function(project_descriptor_new)

  map_new()
  ans(package_handle)
  map_set(${package_handle} uri "project")
  map_new()
  ans(package_descriptor)
  map_set(${package_handle} package_descriptor ${package_descriptor})
  map_new()
  ans(package_dependencies)
  map_set(${package_descriptor} dependencies ${package_dependencies})


  foreach(arg ${ARGN})
    if("${arg}" MATCHES "!(.+)")
      map_set("${package_dependencies}" "${CMAKE_MATCH_1}" false)
    else()
      map_set("${package_dependencies}" "${arg}" true)
    endif()
  endforeach()
  return_ref(package_handle)
endfunction()