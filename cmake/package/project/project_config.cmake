## parses the project config
function(project_config )
  set(args "${ARGN}")

  list_pop_front(args)
  ans(config)
  if(NOT config STREQUAL "" 
     AND EXISTS "${config}" 
     AND NOT IS_DIRECTORY "${config}")
    fread_data("${config}")
    ans(config)
    if(NOT config)
      return()
    endif()
  else()
    obj("${config}")
    ans(config)
  endif()

  map_defaults(
    "${config}"
  "{
    config_dir:'.cps',
    content_dir:'.',
    dependency_dir:'packages',
    config_file:'.cps/config.qm',
    package_descriptor_file:'.cps/package_descriptor.qm'
  }")
  ans(config)

  return_ref(config)

endfunction()