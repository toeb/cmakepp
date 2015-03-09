## adds a package soruce to the composite package soruce
function(composite_package_source_add source)
  map_tryget(${source} source_name)
  ans(source_name)

  if(NOT source_name)
    message(FATAL_ERROR "source_name needs to be set")
  endif()
  assign("!this.children.${source_name}" = source)
  return()
endfunction()