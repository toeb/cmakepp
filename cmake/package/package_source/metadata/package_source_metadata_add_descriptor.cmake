
  function(package_source_metadata_add_descriptor package_descriptor)
    obj("${package_descriptor}")
    ans(package_descriptor)

    if(NOT package_descriptor)
      message(FATAL_ERROR " no valid package_descriptor")
    endif()
    assign(id = package_descriptor.id)
    if(NOT id)
      message(FATAL_ERROR "no valid package id")
    endif()
    
    map_clone_deep("${package_descriptor}")
    ans(package_descriptor)
    
    this_get(metadata)
    map_set(${metadata} ${id} ${package_descriptor})
    
    return_ref(package_descriptor)
  endfunction()