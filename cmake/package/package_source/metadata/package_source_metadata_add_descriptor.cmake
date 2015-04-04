
  function(package_source_metadata_add_descriptor package_descriptor)
    obj("${package_descriptor}")
    ans(package_descriptor)

    if(NOT package_descriptor)
      message(FATAL_ERROR "package_source_metadata_add_descriptor: no valid package_descriptor")
    endif()

    map_import_properties(${package_descriptor} id version make_current)
    if(NOT version)
      set(version "0.0.0")
    endif()
    map_remove("${package_descriptor}" make_current)

    this_get(metadata)

    assign(id = package_descriptor.id)
    if(NOT id)
      message(FATAL_ERROR "no valid package id")
    endif()
    

    map_clone_deep("${package_descriptor}")
    ans(new_package_descriptor)
    map_tryget(${metadata} "${id}@${version}")
    ans(package_descriptor)
    if(package_descriptor)
      map_clear(${package_descriptor})
      map_copy_shallow(${package_descriptor} ${new_package_descriptor})
      return(${package_descriptor})
    endif()
    set(package_descriptor ${new_package_descriptor})


    map_append(${metadata} "${id}@*" ${package_descriptor})
    map_append(${metadata} "*" ${package_descriptor})

    map_has(${metadata} ${id})
    ans(has_current)
    if(make_current OR NOT has_current)
      map_set(${metadata} ${id} ${package_descriptor})
    endif()  
    map_set(${metadata} "${id}@${version}" ${package_descriptor})
    
    return_ref(package_descriptor)
  endfunction()