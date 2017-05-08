
 parameter_definition(package_handle_build_configurations
  <--package-handle:<any>>
  )
function(package_handle_build_configurations )
  arguments_extract_defined_values(0 ${ARGC} package_handle_build_configurations)    
  ans(args)

  cmake_is_configure_mode()
  ans(is_config)
  if(NOT is_config)
    error("only allowed in configure mode")
    return()
  endif()

  set(builds)
  foreach(config ${CMAKE_CONFIGURATION_TYPES})
    timer_start(buildparams)
    build_params(--config "${config}")
    ans(build_params)
    timer_print_elapsed(buildparams)
    timer_start(buildconfig)
    package_handle_build_config("${package_handle}" "${build_params}")
    ans_append(builds)
    timer_print_elapsed(buildconfig)
  endforeach()

  return_ref(builds)
endfunction()