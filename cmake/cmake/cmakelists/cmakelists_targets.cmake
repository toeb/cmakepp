

  ## returns all targets defined in cmakelsits file
  function(cmakelists_targets cmakelists) 

    map_tryget(${cmakelists} begin)
    ans(begin)
    cmake_token_range_invocations_filter("${begin}"
      invocation_identifier MATCHES "^add_(executable)|(library)$"
     )
    ans(target_invocations)
    set(targets)
    foreach(target_invocation ${target_invocations})
      map_tryget(${target_invocation} invocation_arguments)
      ans_extract(target_name)
      ans(target_arguments)
      map_tryget(${target_invocation} invocation_identifier)
      ans(target_type)
      if("${target_type}" MATCHES "^add_(.*)")
        set(target_type "${CMAKE_MATCH_1}")
      endif()
      map_capture_new(target_name target_type target_arguments)
      ans_append(targets)
    endforeach()
    return_ref(targets)
  endfunction()