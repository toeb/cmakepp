
  function(package_source_best_match __lst uri)
    uri("${uri}")
    ans(uri)

    list_to_map(${__lst} "[](m)map_tryget({{m}} source_name)")
    ans(map)

    map_tryget("${uri}" schemes)
    ans(schemes)
    

    set(source)
    foreach(scheme ${schemes})
      map_tryget(${map} ${scheme})
      ans(source)
      if(source)
        break()
      endif()
    endforeach()

    if(NOT source)
      list_peek_front(${__lst})
      ans(source)
    endif()
    return_ref(source)
  endfunction()

  function(package_source_rate package_source uri)
    uri("${uri}")
    ans(uri)

    return(0)
  endfunction()
  