## sets the default package source
function(default_package_source_set source)
  package_source(${source} ${ARGN})
  ans(source)
  if(NOT source)
    message(FATAL_ERROR "invalid package source")
  endif()
  map_set(global default_package_source "${source}")
endfunction()